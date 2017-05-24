call plug#begin('~/.local/share/nvim/plugged')

Plug 'easymotion/vim-easymotion'
Plug 'christoomey/vim-tmux-navigator'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'flazz/vim-colorschemes'
Plug 'chriskempson/base16-vim'
Plug 'tpope/vim-sleuth'
Plug 'danro/rename.vim'
Plug 'ervandew/supertab'
Plug 'cakebaker/scss-syntax.vim'
Plug 'tpope/vim-surround'
Plug 'tomtom/tcomment_vim'
Plug 'xolox/vim-misc'
"Plug 'xolox/vim-session'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-liquid'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'w0rp/ale'
Plug 'sonph/onehalf', { 'rtp': 'vim/' }
Plug 'edkolev/tmuxline.vim'
Plug 'rakr/vim-one'
Plug 'lifepillar/vim-solarized8'
Plug 'terryma/vim-multiple-cursors'
Plug 'hdima/python-syntax'
Plug 'sstallion/vim-whitespace'

call plug#end()

:imap `` <Esc>

set termguicolors
set mouse=a
let g:solarized_term_italics = 1
let g:airline_theme = 'solarized'
colorscheme solarized8_light_high

let g:airline#extensions#tmuxline#enabled = 0
let g:tmuxline_theme='vim_statusline_3'

:command! EditInit :e ~/.config/nvim/init.vim
:command! -bar SourceInit :source ~/.config/nvim/init.vim
:command! Replug SourceInit|PlugUpdate

let mapleader="\<Space>"

" Remap macro key to leader q
noremap <Leader>q q
noremap q <Nop>

nmap <silent> <leader>p :FZF<cr>

" Clear search map on esc
nnoremap <esc> :noh<return><esc>

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

autocmd BufLeave term://* stopinsert

:set ignorecase
:set smartcase

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

let g:deoplete#enable_at_startup = 1
" deoplete keys, ctrl-space to open and tab to cycle
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <C-Space> <C-x><C-o>

" leader leader-w buffer close
nmap <leader><leader>w :bd<CR>

let python_highlight_all = 1

highlight! link ExtraWhitespace ErrorMsg

:set number

