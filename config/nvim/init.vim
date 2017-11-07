call plug#begin('~/.local/share/nvim/plugged')

Plug 'easymotion/vim-easymotion'
Plug 'christoomey/vim-tmux-navigator'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-sleuth'
Plug 'danro/rename.vim'
Plug 'ervandew/supertab'
Plug 'tpope/vim-surround'
Plug 'xolox/vim-misc'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'w0rp/ale'
Plug 'edkolev/tmuxline.vim'
Plug 'lifepillar/vim-solarized8'
Plug 'terryma/vim-multiple-cursors'
Plug 'sstallion/vim-whitespace'
Plug 'junegunn/vim-easy-align'
Plug 'hashivim/vim-terraform'
Plug 'juliosueiras/vim-terraform-completion'
Plug 'mhinz/vim-signify'
Plug 'sbdchd/neoformat'
Plug 'kopischke/vim-stay'
"Plug 'Yggdroot/indentLine'
Plug 'mhinz/vim-sayonara', { 'on' : 'Sayonara' }

call plug#end()

:imap `` <Esc>

" vim-stay persistence
silent !mkdir ~/.config/nvim/undo > /dev/null 2>&1
set viewoptions=cursor,folds,slash,unix
set undofile
set undodir=~/.config/nvim/undo
" vim-stay persistence

" Yggdroot/indentLine solarized color
let g:indentLine_color_gui = '#eee8d5'
let g:indentLine_char = '│'
let g:indentLine_enabled = 1
let g:vim_json_syntax_conceal = 0
let g:indentLine_noConcealCursor='nc'
let g:vim_json_syntax_conceal = 0

set termguicolors
set mouse=a
let g:solarized_term_italics = 1
colorscheme solarized8_light_high
let g:airline_theme = 'solarized'

let g:airline#extensions#tmuxline#enabled = 0

:command! EditInit :e ~/.config/nvim/init.vim
:command! -bar SourceInit :source ~/.config/nvim/init.vim
:command! Replug SourceInit|PlugUpdate

let mapleader="\<Space>"

" Disable macro key
noremap q <Nop>

nnoremap <C-w> :Sayonara<cr>
nnoremap <C-s> :w<cr>
nmap <silent> <leader>p :FZF<cr>


set clipboard+=unnamedplus
noremap <leader>y "+y


let @q = "ysiw'"
let @d = 'ysiw"'
nnoremap <M-'> @q
nnoremap <M-"> @d

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

" Just show the filename (no path) in the tab
let g:airline#extensions#tabline#fnamemod = ':t'

let g:deoplete#enable_at_startup = 1
" deoplete keys, ctrl-space to open and tab to cycle
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <C-Space> <C-x><C-o>

" leader leader-w buffer close
nmap <leader><leader>w :bd<CR>

:set hidden

" Disable useless archaic vim garbage hotkeys
nnoremap Q <nop>

let python_highlight_all = 1

highlight! link ExtraWhitespace ErrorMsg

:set number

let g:neoformat_python_yapf = {
            \ 'exe': 'python',
            \ 'args': ["-m yapf", "--style='{based_on_style: pep8, column_limit: 120}'"],
            \ 'replace': 0,
            \ 'stdin': 1,
            \ 'no_append': 1,
            \ }

let g:neoformat_enabled_python = ['yapf']

" Allows for editing files in same dir as buffer: edit %%/filename
cabbr <expr> %% expand('%:p:h')

" Disable dumb garbage "scratch" preview window
set completeopt-=preview

:set linebreak
