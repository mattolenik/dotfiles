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

