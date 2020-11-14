if exists('g:vscode')
call plug#begin('~/.local/share/nvim-vscode/plugged')

let mapleader="\<Space>"
Plug 'asvetliakov/vim-easymotion'

else

call plug#begin('~/.local/share/nvim/plugged')

Plug 'neomake/neomake'

Plug 'xolox/vim-misc'

" Colors
Plug 'lifepillar/vim-solarized8'
Plug 'dunstontc/vim-vscode-theme'

" Cursor/Edit
Plug 'easymotion/vim-easymotion'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-surround'  " bracket group actions () [] {}
Plug 'tpope/vim-repeat'  " improved action repeat
Plug 'brooth/far.vim'  " find and replace

" IDE
Plug 'edkolev/tmuxline.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'mhinz/vim-sayonara', { 'on' : 'Sayonara' }  " unified buffer/window close
Plug 'tpope/vim-sleuth'    " tab width autodetect
Plug 'kopischke/vim-stay'  " session management
Plug 'danro/rename.vim'    " file rename
Plug 'ervandew/supertab'   " better tabs

" Formatting
Plug 'sstallion/vim-whitespace'
Plug 'junegunn/vim-easy-align'
Plug 'sbdchd/neoformat'
Plug 'rhysd/vim-clang-format'
Plug 'kana/vim-operator-user'
Plug 'vim-scripts/AdvancedSorters'

" Languages
Plug 'sheerun/vim-polyglot'
Plug 'vim-syntastic/syntastic'
Plug 'hashivim/vim-terraform'
Plug 'juliosueiras/vim-terraform-completion'
"Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
"Plug 'nsf/gocode', { 'rtp': 'nvim', 'do': '~/.local/share/nvim/plugged/gocode/nvim/symlink.sh' }
"Plug 'mdempsky/gocode', { 'rtp': 'nvim', 'do': '~/.local/share/nvim/plugged/gocode/nvim/symlink.sh' }
Plug 'arrufat/vala.vim'
"Plug 'posva/vim-vue'
"Plug 'OmniSharp/omnisharp-vim'
"Plug 'cjrh/vim-conda'

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

"" Scala
"Plug 'ensime/ensime-vim', { 'do': ':UpdateRemotePlugins' }
Plug 'derekwyatt/vim-scala'
autocmd BufWritePost *.scala silent :EnTypeCheck
nnoremap <localleader>t :EnType<CR>
au FileType scala nnoremap <localleader>df :EnDeclaration<CR>

" Autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'juliosueiras/vim-terraform-completion'

" Linting
Plug 'w0rp/ale'
let g:ale_sh_shellcheck_options = '-x'
Plug 'mhinz/vim-signify'

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
let g:indentLine_noConcealCursor='nc'
let g:vim_json_syntax_conceal = 0
let g:vim_json_syntax_conceal = 0

let g:syntastic_vala_modules = 'gio-2.0 gtk+-3.0 gee'
"let g:syntastic_vala_vapi_dirs = '/usr/share/vala-0.40/vapi'
let g:syntastic_python_checkers = ['pylint']
let g:syntastic_python_pylint_post_args='--max-line-length=120'
let g:syntastic_python_pylint_args='--max-line-length=120'

set termguicolors
set mouse=a
let g:solarized_term_italics = 1
colorscheme dark_plus
let g:airline_theme = 'codedark'
if $THEME_TINT == 'dark'
    set background=dark
    let g:airline_solarized_bg='dark'
else
    set background=light
    let g:airline_solarized_bg='light'
endif

let g:airline#extensions#tmuxline#enabled = 0

:command! EditInit :e ~/.config/nvim/init.vim
:command! -bar SourceInit :source ~/.config/nvim/init.vim
:command! Replug SourceInit|PlugUpdate
:command! ChmodX :!chmod +x %

let mapleader="\<Space>"

" Disable macro key
"noremap q <Nop>

nnoremap <C-w> :Sayonara<cr>
nnoremap <C-s> :w<cr>
nmap <silent> <leader>p :FZF<cr>


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

" deoplete keys, ctrl-space to open and tab to cycle
"inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
"inoremap <C-Space> <C-x><C-o>

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

" vim-conda fix
" https://github.com/cjrh/vim-conda
let g:jedi#force_py_version = 2
let g:UltisnipsUsePythonVersion = 2

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


end
