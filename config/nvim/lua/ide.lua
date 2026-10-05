-- IDE / code-browsing setup: native LSP, telescope pickers, treesitter,
-- aerial outline, mouse bindings and the right-click menu.
-- Loaded from init.vim via `lua require('ide')`.

local map = vim.keymap.set

-- Plugins may not be installed yet on a fresh checkout (first :PlugInstall).
local function try_require(name)
  local ok, mod = pcall(require, name)
  if not ok then
    vim.schedule(function()
      vim.notify(('ide.lua: %s not available (run :PlugInstall)'):format(name), vim.log.levels.WARN)
    end)
    return nil
  end
  return mod
end

---------------------------------------------------------------------------
-- Filetype fallback
---------------------------------------------------------------------------

-- vim-polyglot sets g:did_load_filetypes, which turns off Neovim's own
-- filetype.lua. Polyglot doesn't know some types Neovim does (e.g. wgsl),
-- so fill in anything it left blank from the built-in table.
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group = vim.api.nvim_create_augroup('ide_filetype_fallback', { clear = true }),
  callback = function(ev)
    if vim.bo[ev.buf].filetype ~= '' then return end
    local ft = vim.filetype.match({ buf = ev.buf })
    if ft then vim.bo[ev.buf].filetype = ft end
  end,
})

---------------------------------------------------------------------------
-- LSP servers (configs come from nvim-lspconfig's lsp/ directory)
---------------------------------------------------------------------------

-- vtsls: VSCode's TypeScript server behind LSP. Uses the project's own
-- node_modules/typescript and tsconfig.json.
vim.lsp.config('vtsls', {
  settings = {
    vtsls = { autoUseWorkspaceTsdk = true },
    typescript = {
      preferences = { includePackageJsonAutoImports = 'off' },
      tsserver = { maxTsServerMemory = 4096 },
    },
  },
})

-- wgsl-analyzer doesn't understand the build's `//:) include` preprocessor
-- directive, so cross-file symbols show as unresolved. Keep navigation and
-- hover, but don't nag about it.
vim.lsp.config('wgsl_analyzer', {
  handlers = {
    ['textDocument/publishDiagnostics'] = function() end,
  },
})

-- Only enable servers whose executable is actually on PATH, otherwise
-- Neovim complains on every FileType event.
local servers = {
  vtsls = 'vtsls',
  wgsl_analyzer = 'wgsl-analyzer',
  lua_ls = 'lua-language-server',
  gopls = 'gopls',
}
for name, exe in pairs(servers) do
  if vim.fn.executable(exe) == 1 then
    vim.lsp.enable(name)
  end
end
-- `deno` is on PATH but this is a Node/pnpm codebase. Never attach it.
vim.lsp.enable('denols', false)

vim.diagnostic.config({
  severity_sort = true,
  virtual_text = { current_line = true },
  float = { border = 'rounded', source = true },
})

---------------------------------------------------------------------------
-- Telescope
---------------------------------------------------------------------------

local telescope = try_require('telescope')
local builtin = try_require('telescope.builtin')
if telescope then
  local themes = require('telescope.themes')
  telescope.setup({
    defaults = {
      path_display = { 'truncate' },
      layout_strategy = 'flex',
      layout_config = { flex = { flip_columns = 160 } },
      dynamic_preview_title = true,
    },
    pickers = {
      lsp_references = { fname_width = 60, include_declaration = false },
      lsp_definitions = { fname_width = 60 },
      lsp_implementations = { fname_width = 60 },
      lsp_document_symbols = { symbol_width = 50 },
      lsp_dynamic_workspace_symbols = { fname_width = 60 },
    },
    extensions = {
      ['ui-select'] = { themes.get_dropdown({}) },
    },
  })
  pcall(telescope.load_extension, 'fzf')
  pcall(telescope.load_extension, 'ui-select')
  pcall(telescope.load_extension, 'aerial')
end

---------------------------------------------------------------------------
-- Treesitter (main branch: parsers are installed explicitly, highlighting
-- is started per buffer with vim.treesitter.start)
---------------------------------------------------------------------------

local ts_langs = {
  'typescript', 'javascript', 'tsx', 'jsdoc', 'wgsl', 'lua', 'go', 'gomod',
  'json', 'jsonc', 'yaml', 'toml', 'markdown', 'markdown_inline', 'bash',
  'vim', 'vimdoc', 'query', 'c', 'cpp', 'rust', 'python', 'html', 'css',
  'make', 'dockerfile', 'regex', 'diff', 'gitcommit', 'git_rebase',
}

if try_require('nvim-treesitter') then
  vim.api.nvim_create_user_command('TSInstallAll', function()
    require('nvim-treesitter').install(ts_langs)
  end, { desc = 'Install all treesitter parsers used by ide.lua' })

  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('ide_treesitter', { clear = true }),
    callback = function(ev)
      -- Silently skip filetypes with no parser installed.
      pcall(vim.treesitter.start, ev.buf)
    end,
  })
end

---------------------------------------------------------------------------
-- Aerial symbol outline
---------------------------------------------------------------------------

local aerial = try_require('aerial')
if aerial then
  aerial.setup({
    backends = { 'lsp', 'treesitter', 'markdown', 'man' },
    layout = { default_direction = 'right', min_width = 32 },
    show_guides = true,
    highlight_on_hover = true,
    autojump = true,
    filter_kind = {
      'Class', 'Constructor', 'Enum', 'Function', 'Interface', 'Module',
      'Method', 'Struct', 'Property', 'Field', 'Constant',
    },
    on_attach = function(bufnr)
      -- These buffer-local maps shadow cinnamon's global `{` / `}` paragraph
      -- maps, so route the symbol jump through cinnamon to keep it smooth.
      local function jump(cmd)
        return function()
          local ok, cinnamon = pcall(require, 'cinnamon')
          if ok then cinnamon.scroll(function() vim.cmd(cmd) end) else vim.cmd(cmd) end
        end
      end
      map('n', '{', jump('AerialPrev'), { buffer = bufnr, desc = 'Previous symbol' })
      map('n', '}', jump('AerialNext'), { buffer = bufnr, desc = 'Next symbol' })
    end,
  })
  map('n', '<leader>o', '<cmd>AerialToggle!<CR>', { desc = 'Toggle symbol outline' })
  map('n', '<leader>O', '<cmd>AerialNavToggle<CR>', { desc = 'Symbol nav popup' })
end

---------------------------------------------------------------------------
-- Go to definition helpers
---------------------------------------------------------------------------

local function has_lsp(method)
  return #vim.lsp.get_clients({ bufnr = 0, method = method }) > 0
end

-- Definition via telescope when an LSP is attached (picker for multiple
-- hits, direct jump for one), otherwise fall back to tag jump.
local function goto_definition(opts)
  if has_lsp('textDocument/definition') and builtin then
    builtin.lsp_definitions(opts)
  elseif has_lsp('textDocument/definition') then
    vim.lsp.buf.definition()
  else
    vim.cmd([[execute "normal! g\<C-]>"]])
  end
end

---------------------------------------------------------------------------
-- Keymaps
---------------------------------------------------------------------------

-- Global pickers (work in any buffer with an LSP attached).
if builtin then
  map('n', '<leader>fr', builtin.lsp_references, { desc = 'LSP references' })
  map('n', '<leader>fd', builtin.lsp_definitions, { desc = 'LSP definitions' })
  map('n', '<leader>fi', builtin.lsp_implementations, { desc = 'LSP implementations' })
  map('n', '<leader>ft', builtin.lsp_type_definitions, { desc = 'LSP type definitions' })
  map('n', '<leader>fs', builtin.lsp_document_symbols, { desc = 'Document symbols' })
  map('n', '<leader>fS', builtin.lsp_dynamic_workspace_symbols, { desc = 'Workspace symbols' })
  map('n', '<leader>fe', builtin.diagnostics, { desc = 'Diagnostics' })
  map('n', '<leader>fc', builtin.lsp_incoming_calls, { desc = 'Incoming calls' })
  map('n', '<leader>fC', builtin.lsp_outgoing_calls, { desc = 'Outgoing calls' })
end

-- Buffer-local maps once a server attaches. Neovim 0.11+ already provides
-- grr / gri / grn / gra / grt / gO / K / <C-]> / <C-t>; these add the rest.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('ide_lsp_attach', { clear = true }),
  callback = function(ev)
    local function bmap(mode, lhs, rhs, desc)
      map(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
    end
    bmap('n', 'gd', goto_definition, 'Go to definition')
    bmap('n', 'gD', vim.lsp.buf.declaration, 'Go to declaration')
    bmap('n', '<leader>gv', function() goto_definition({ jump_type = 'vsplit' }) end,
      'Definition in vsplit')
    bmap('n', '<leader>gs', function() goto_definition({ jump_type = 'split' }) end,
      'Definition in split')
    bmap('n', 'gl', vim.diagnostic.open_float, 'Line diagnostics')
    bmap('n', '<M-g>', goto_definition, 'Go to definition')
    bmap('n', '<M-r>', vim.lsp.buf.rename, 'Rename symbol')
    bmap('i', '<C-k>', vim.lsp.buf.signature_help, 'Signature help')
  end,
})

-- Mouse: Ctrl-click jumps to definition. Ctrl-right-click opens the PopUp
-- menu: herdr swallows plain right-clicks for its own pane menu and only
-- forwards them with Ctrl held (ui.right_click_passthrough_modifier), so
-- inside herdr Ctrl+right-click *is* the right-click. Back is <C-t> / <C-o>
-- or the menu's "Back" entry.
map('n', '<C-LeftMouse>', function()
  -- Move the cursor to the clicked position first, then jump.
  local m = vim.fn.getmousepos()
  if m.winid ~= 0 then
    vim.api.nvim_set_current_win(m.winid)
    pcall(vim.api.nvim_win_set_cursor, m.winid, { m.line, math.max(m.column - 1, 0) })
  end
  goto_definition()
end, { desc = 'Go to definition (mouse)' })
map('n', '<C-RightMouse>', '<RightMouse>', { remap = false, desc = 'Context menu (mouse)' })
map('n', '<C-RightRelease>', '<RightRelease>', { remap = false })
-- Swallow the release so it doesn't start a selection.
map('n', '<C-LeftRelease>', '<Nop>')

---------------------------------------------------------------------------
-- Mouse wheel: coalesce notch bursts
---------------------------------------------------------------------------

-- A physical wheel notch arrives as 3 wheel events in the same input batch
-- (sub-millisecond apart), and 'mousescroll' then moves 3 lines per event,
-- so one notch = 9 lines. Trackpad events arrive one per line of travel at
-- display-refresh spacing (~8-16 ms), so they feel right as-is. Swallow any
-- wheel event that follows the previous one within `wheel_coalesce_ms`,
-- which turns a notch into a single 3-line scroll and leaves the trackpad
-- alone. Tune with :let g:wheel_coalesce_ms = N; :let g:wheel_debug = 1
-- prints inter-event gaps to :messages for calibration.
local wheel_last = { up = 0, down = 0 }
local function wheel(dir, key)
  local termcode = vim.api.nvim_replace_termcodes(key, true, false, true)
  return function()
    local now = vim.uv.hrtime()
    local gap_ms = (now - wheel_last[dir]) / 1e6
    wheel_last[dir] = now
    if vim.g.wheel_debug == 1 then
      vim.notify(('wheel %s gap=%.2fms'):format(dir, gap_ms), vim.log.levels.INFO)
    end
    if gap_ms < (vim.g.wheel_coalesce_ms or 4) then return end
    -- 'n' = noremap, so this runs the built-in scroll, not this mapping again.
    vim.api.nvim_feedkeys(termcode, 'n', false)
  end
end
map({ 'n', 'x', 'i' }, '<ScrollWheelDown>', wheel('down', '<ScrollWheelDown>'), { desc = 'Wheel down (coalesced)' })
map({ 'n', 'x', 'i' }, '<ScrollWheelUp>', wheel('up', '<ScrollWheelUp>'), { desc = 'Wheel up (coalesced)' })

---------------------------------------------------------------------------
-- Right-click menu
---------------------------------------------------------------------------

vim.cmd([[
  silent! aunmenu PopUp.How-to\ disable\ mouse
  silent! aunmenu PopUp.-1-
  nmenu 500.300 PopUp.Go\ to\ definition        <Cmd>lua require('ide').goto_definition()<CR>
  nmenu 500.301 PopUp.Go\ to\ declaration       <Cmd>lua vim.lsp.buf.declaration()<CR>
  nmenu 500.302 PopUp.Go\ to\ type\ definition  <Cmd>lua vim.lsp.buf.type_definition()<CR>
  nmenu 500.303 PopUp.Go\ to\ implementation    <Cmd>lua require('telescope.builtin').lsp_implementations()<CR>
  nmenu 500.304 PopUp.Find\ references          <Cmd>lua require('telescope.builtin').lsp_references()<CR>
  nmenu 500.305 PopUp.Incoming\ calls           <Cmd>lua require('telescope.builtin').lsp_incoming_calls()<CR>
  nmenu 500.306 PopUp.-Sep1- :
  nmenu 500.307 PopUp.Hover                     <Cmd>lua vim.lsp.buf.hover()<CR>
  nmenu 500.308 PopUp.Rename                    <Cmd>lua vim.lsp.buf.rename()<CR>
  nmenu 500.309 PopUp.Code\ action              <Cmd>lua vim.lsp.buf.code_action()<CR>
  nmenu 500.310 PopUp.-Sep2- :
  nmenu 500.311 PopUp.Symbol\ outline           <Cmd>AerialToggle!<CR>
  nmenu 500.312 PopUp.Back                      <C-t>
  nmenu 500.313 PopUp.-Sep3- :
]])

return {
  goto_definition = goto_definition,
  ts_langs = ts_langs,
}
