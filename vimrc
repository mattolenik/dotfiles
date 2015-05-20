if has('vim_starting')
    set nocompatible               " Be iMproved
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

filetype off                  " required

let g:airline_powerline_fonts=1

call plug#begin('~/.vim/plugged')

Plug 'mattolenik/vim-projectrc'
Plug 'mattolenik/vim-gnometerminal-cursor'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'xml.vim'
Plug 'yaifa.vim'
Plug 'Tabmerge'
Plug 'Lokaltog/vim-easymotion'
Plug 'vim-ruby/vim-ruby'
Plug 'myusuf3/numbers.vim'
Plug 'bling/vim-airline'
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'christoomey/vim-tmux-navigator'
Plug 'mhinz/vim-tmuxify'
Plug 'zeis/vim-kolor'
Plug 'Valloric/YouCompleteMe'
Plug 'christoomey/vim-tmux-navigator'
Plug 'zeis/vim-kolor'
Plug 'junegunn/seoul256.vim'
Plug 'scrooloose/syntastic'
Plug 'edkolev/tmuxline.vim'
Plug 'fweep/vim-tabber'
Plug 'kien/ctrlp.vim'
Plug 'majutsushi/tagbar'
Plug 'xolox/vim-session'
Plug 'xolox/vim-misc'
Plug 'fatih/vim-go'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'

call plug#end()

syntax on
filetype plugin indent on     " required!

set number

set t_Co=256
set t_ut=

set mouse=a

"Search highlighting
:set hlsearch
":hi Search guibg=LightBlue

":hi Visual ctermbg=239
set cursorline

" Press Space to turn off highlighting and clear any message already displayed.
:nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

set wrap!

let mapleader=","

"Indent folding
"set foldenable
"set fdm=indent

"Incremental search with ignore case, except explicit caps
set incsearch
set ignorecase
set smartcase

"Set swap and backup files to the tmp location
set directory=~/.vimswap//,/var/tmp//,/tmp//,.
set backupdir=~/.vimswap//,/var/tmp//,/tmp//,.
set undodir=~/.vimswap//,/var/tmp//,/tmp//,.

" Kolor settings
let g:kolor_italic=1                    " Enable italic. Default: 1
let g:kolor_bold=1                      " Enable bold. Default: 1
let g:kolor_underlined=1                " Enable underline. Default: 0
let g:kolor_alternative_matchparen=0    " Gray 'MatchParen' color. Default: 0

colorscheme kolor

let g:neocomplete#enable_at_startup=1

set tabline=%!tabber#TabLine()
let g:tabber_divider_style = 'fancy'

let g:indent_guides_auto_colors = 0
hi IndentGuidesEven ctermbg=237
hi IndentGuidesOdd  ctermbg=236

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_root_markers = ['.gosrc']
let g:ctrlp_custom_ignore = { 'dir': '^dist' }

" Ignore node_modules in ctrlp searches
set wildignore+=*/node_modules/*

nmap <F8> :TagbarToggle<CR>

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

autocmd FileType go setlocal shiftwidth=4 tabstop=4
if has("mouse_sgr")
    set ttymouse=sgr
else
    set ttymouse=xterm2
end

if has("unix")
  let s:uname = system("uname")
  if s:uname == "Darwin\n"
    " Do Mac stuff here
    set clipboard=unnamed
  endif
endif

hi CursorLine ctermbg=237
hi MatchParen ctermbg=241
hi MatchParen ctermfg=250

" vim-session aliases
let g:session_command_aliases = 1

augroup vagrant
  au!
  au BufRead,BufNewFile Vagrantfile set filetype=ruby
augroup END

" Compatible with ranger 1.4.2 through 1.6.*
"
" Add ranger as a file chooser in vim
"
" If you add this code to the .vimrc, ranger can be started using the command
" ":RangerChooser" or the keybinding "<leader>r".  Once you select one or more
" files, press enter and ranger will quit again and vim will open the selected
" files.

function! RangeChooser()
    let temp = tempname()
    " The option "--choosefiles" was added in ranger 1.5.1. Use the next line
    " with ranger 1.4.2 through 1.5.0 instead.
    "exec 'silent !ranger --choosefile=' . shellescape(temp)
    exec 'silent !ranger --choosefiles=' . shellescape(temp)
    if !filereadable(temp)
        redraw!
        " Nothing to read.
        return
    endif
    let names = readfile(temp)
    if empty(names)
        redraw!
        " Nothing to open.
        return
    endif
    " Edit the first item.
    exec 'tabedit ' . fnameescape(names[0])
    " Add any remaning items to the arg list/buffer list.
    for name in names[1:]
        exec 'argadd ' . fnameescape(name)
    endfor
    redraw!
endfunction
command! -bar RangerChooser call RangeChooser()
nnoremap <leader>r :<C-U>RangerChooser<CR>

" Auto close scratch window, used by autocomplete plugins
autocmd CompleteDone * pclose
