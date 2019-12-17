set nocompatible                  " be iMproved, required
filetype off                      " required
set rtp+=~/.vim/bundle/Vundle.vim " set the runtime path to include Vundle and initialize 
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'     " let Vundle manage Vundle, required
Plugin 'davidhalter/jedi-vim'     " jedi-vim
Plugin 'pangloss/vim-javascript'  " javascript indentation 
Plugin 'chiel92/vim-autoformat'   " autoformat?
Plugin 'tidalcycles/vim-tidal'    " Vim bindings for Tidal Cycles

" All of your Plugins must be added before the following line
call vundle#end()                 " required
filetype plugin indent on         " required
 
" Put your non-Plugin stuff after this line
colo murphy      " set colorscheme 
syntax enable    " enable syntax highlighting 
set number       " show line numbers 
set ts=4         " set tabs to have 4 spaces
set autoindent   " indent when moving to the next line while writing code 
set expandtab    " expand tabs into spaces 
set shiftwidth=4 " when using the >> or << commands, shift lines by 4 spaces 
set cursorline   " show a visual line under the cursor's current line 
set showmatch    " show the matching part of the pair for [] {} and () 
set laststatus=2 " display file name on the bottom bar
let maplocalleader=","
