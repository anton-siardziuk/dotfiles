set t_Co=256
colorscheme mustango

set nocompatible
filetype off

set rtp+=/usr/local/go/misc/vim
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'nsf/gocode', {'rtp': 'vim/'}
call vundle#end()
filetype plugin indent on

syntax on
set cursorline

set number
