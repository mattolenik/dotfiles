call plug#begin('~/.local/share/nvim/plugged')

Plug 'easymotion/vim-easymotion'

call plug#end()

let mapleader=","

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

autocmd BufLeave term://* stopinsert
