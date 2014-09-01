if has('vim_starting')
    set nocompatible               " Be iMproved
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

filetype off                  " required

let g:airline_powerline_fonts=1

call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'mattolenik/vim-projectrc'
NeoBundle 'mattolenik/vim-gnometerminal-cursor'
NeoBundle 'tpope/vim-sensible'
NeoBundle 'tpope/vim-surround'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'xml.vim'
NeoBundle 'yaifa.vim'
NeoBundle 'Tabmerge'
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'myusuf3/numbers.vim'
NeoBundle 'bling/vim-airline'
NeoBundle 'Shougo/vimproc.vim'
NeoBundle 'christoomey/vim-tmux-navigator'
NeoBundle 'zeis/vim-kolor'
NeoBundle 'junegunn/seoul256.vim'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'edkolev/tmuxline.vim'
NeoBundle 'fweep/vim-tabber'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'lukaszkorecki/CoffeeTags'
NeoBundle 'xolox/vim-session'
NeoBundle 'xolox/vim-misc'

call neobundle#end()

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

:map <C-X> :Unite file buffer

set tabline=%!tabber#TabLine()
let g:tabber_divider_style = 'fancy'

let g:indent_guides_auto_colors = 0
hi IndentGuidesEven ctermbg=237
hi IndentGuidesOdd  ctermbg=236

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" Ignore node_modules in ctrlp searches
set wildignore+=*/node_modules/*

nmap <F8> :TagbarToggle<CR>

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif


hi CursorLine ctermbg=237
hi MatchParen ctermbg=241
hi MatchParen ctermfg=250

augroup vagrant
  au!
  au BufRead,BufNewFile Vagrantfile set filetype=ruby
augroup END
