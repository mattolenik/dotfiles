call plug#begin('~/.local/share/nvim/plugged')

Plug 'github/copilot.vim'
Plug 'neomake/neomake'

" Colors
Plug 'chriskempson/base16-vim'
Plug 'dawikur/base16-vim-airline-themes'

" Cursor/Edit
Plug 'easymotion/vim-easymotion'
Plug 'mg979/vim-visual-multi'
Plug 'tpope/vim-surround'  " bracket group actions () [] {}
Plug 'tpope/vim-repeat'  " improved action repeat
Plug 'brooth/far.vim'  " find and replace

" IDE
Plug 'edkolev/tmuxline.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ojroques/nvim-bufdel'  " Better buffer deletion
Plug 'tpope/vim-sleuth'    " tab width autodetect
Plug 'danro/rename.vim'    " file rename
Plug 'ervandew/supertab'   " better tabs

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }

" GUI
Plug 'nvim-tree/nvim-web-devicons'

" Formatting
Plug 'sstallion/vim-whitespace'  " Adds command :WhitespaceStrip to remove trailing whitespace
Plug 'junegunn/vim-easy-align'
Plug 'vim-scripts/AdvancedSorters'

" Languages
Plug 'sheerun/vim-polyglot'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Autocomplete
Plug 'neovim/nvim-lspconfig'
Plug 'glepnir/lspsaga.nvim', { 'branch': 'main' }

" Linting
Plug 'dense-analysis/ale'
let g:ale_sh_shellcheck_options = '-x'
Plug 'mhinz/vim-signify'

call plug#end()

set fillchars+=eob:\ " Keep trailing space, the value is an escaped space

:imap `` <Esc>

silent !mkdir ~/.config/nvim/undo > /dev/null 2>&1
set viewoptions=cursor,folds,slash,unix
set undofile
set undodir=~/.config/nvim/undo

set termguicolors
set mouse=a
let g:solarized_term_italics = 1
colorscheme base16-tomorrow-night-eighties
let g:airline#extensions#tmuxline#enabled = 1

:command! EditInit :e ~/.config/nvim/init.vim
:command! -bar SourceInit :source ~/.config/nvim/init.vim
:command! Replug SourceInit|PlugUpdate
:command! ChmodX :!chmod +x %

let mapleader="\<Space>"

" Disable macro key
"noremap q <Nop>

" Ctrl-w close tab
nnoremap <C-w> :BufDel<cr>

" Bind ctrl-s to save
nnoremap <C-s> :w<cr>
" Also bind alt-shift-s to save, a key combo which can be sent from Alacritty
" more easily than control-s.
nnoremap <M-S-s> :w<cr>

nnoremap <leader>p <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
"nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
"nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>fr <cmd>lua require('telescope.builtin').lsp_references()<cr>
nnoremap <leader>fd <cmd>lua require('telescope.builtin').lsp_definitions()<cr>
nnoremap <leader>fi <cmd>lua require('telescope.builtin').lsp_implementations()<cr>


noremap <leader>y "*y


let @q = "ysiw'"
let @d = 'ysiw"'
nnoremap <M-'> @q
nnoremap <M-"> @d

" alt-` to insert ``` for Markdown
inoremap <M-`> ```

" Clear search map on esc
nnoremap <esc> :noh<return><esc>

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"autocmd BufLeave term://* stopinsert

:set ignorecase
:set smartcase
:set tabstop=4

set nofoldenable

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>T <Plug>AirlineSelectPrevTab
nmap <leader>t <Plug>AirlineSelectNextTab

let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

" leader leader-w buffer close
nmap <leader><leader>w :bd<CR>

:set hidden

" Disable useless archaic vim garbage hotkeys
nnoremap Q <nop>

let python_highlight_all = 1

highlight! link ExtraWhitespace ErrorMsg

:set number
"
" Allows for editing files in same dir as buffer: edit %%/filename
cabbr <expr> %% expand('%:p:h')

" Disable dumb garbage "scratch" preview window
set completeopt-=preview

:set linebreak

set backupdir-=.
set backupdir^=~/.local/share/nvim/swap,~/tmp,/tmp
set directory-=.
set directory^=~/.local/share/nvim/swap,~/tmp,/tmp
set backupdir=~/.local/share/nvim/swap
set directory=~/.local/share/nvim/swap

" Set Alt-dash and alt-backslash to toggle cursorline and cursorcolumn
map <A--> :set cursorline!<CR>
map <A-\> :set cursorcolumn!<CR>

":set cursorcolumn
:set cursorline

" Sort words in selected text
:vnoremap <F2> d:execute 'normal i' . join(sort(split(getreg('"'))), ' ')<CR>

lua <<EOF
    require'lspconfig'.gopls.setup{}
EOF

lua <<EOF
  lspconfig = require "lspconfig"
  util = require "lspconfig/util"

  lspconfig.gopls.setup {
    cmd = {"gopls", "serve"},
    filetypes = {"go", "gomod"},
    root_dir = util.root_pattern("go.work", "go.mod", ".git"),
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
      },
    },
  }
EOF

lua <<EOF
  function go_org_imports(wait_ms)
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
  end
EOF

autocmd BufWritePre *.go lua go_org_imports()

lua <<EOF
local keymap = vim.keymap.set
local saga = require('lspsaga')

saga.init_lsp_saga()

-- Lsp finder find the symbol definition implement reference
-- if there is no implement it will hide
-- when you use action in finder like open vsplit then you can
-- use <C-t> to jump back
keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })

-- Code action
keymap({"n","v"}, "<leader>ca", "<cmd>Lspsaga code_action<CR>", { silent = true })

-- Rename
keymap("n", "gr", "<cmd>Lspsaga rename<CR>", { silent = true })

-- Peek Definition
-- you can edit the definition file in this flaotwindow
-- also support open/vsplit/etc operation check definition_action_keys
-- support tagstack C-t jump back
keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { silent = true })

-- Show line diagnostics
keymap("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })

-- Show cursor diagnostic
keymap("n", "<leader>cd", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { silent = true })

-- Diagnsotic jump can use `<c-o>` to jump back
keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true })
keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })

-- Only jump to error
keymap("n", "[E", function()
  require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true })
keymap("n", "]E", function()
  require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true })

-- Outline
keymap("n","<leader>o", "<cmd>LSoutlineToggle<CR>",{ silent = true })

-- Hover Doc
keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })

-- Float terminal
keymap("n", "<A-d>", "<cmd>Lspsaga open_floaterm<CR>", { silent = true })
-- if you want pass somc cli command into terminal you can do like this
-- open lazygit in lspsaga float terminal
keymap("n", "<A-d>", "<cmd>Lspsaga open_floaterm lazygit<CR>", { silent = true })
-- close floaterm
keymap("t", "<A-d>", [[<C-\><C-n><cmd>Lspsaga close_floaterm<CR>]], { silent = true })
EOF

" More IDEish stuff

nnoremap <M-r> :ALERename<CR>
nnoremap <M-g> :ALEGoToDefinition<CR>

" Right click menu items
lua <<EOF
vim.cmd [[
silent! aunmenu PopUp.How-to\ disable\ mouse
silent! aunmenu PopUp.-1-
nmenu 500.300 PopUp.Go\ to\ definition :ALEGoToDefinition<CR>
nmenu 500.300 PopUp.Go\ to\ implementation :ALEGoToImplementation<CR>
nmenu 500.300 PopUp.Go\ to\ type\ definition :ALEGoToTypeDefinition<CR>
nmenu 500.300 PopUp.Find\ references :ALEFindReferences<CR>
nmenu 500.300 PopUp.Rename :ALERename<CR>
nmenu 500.300 PopUp.-Sep- :
]]
EOF

lua <<EOF
require'nvim-web-devicons'.setup {
 -- your personnal icons can go here (to override)
 -- you can specify color or cterm_color instead of specifying both of them
 -- DevIcon will be appended to `name`
 override = {
  zsh = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "Zsh"
  }
 };
 -- globally enable different highlight colors per icon (default to true)
 -- if set to false all icons will have the default icon's color
 color_icons = true;
 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
 default = true;
}
EOF

