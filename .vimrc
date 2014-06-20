set nocompatible
filetype off

set rtp+=/usr/local/go/misc/vim
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'nsf/gocode', {'rtp': 'vim/'}
Plugin 'Shougo/neocomplcache.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'altercation/vim-colors-solarized'
call vundle#end()
filetype plugin indent on

syntax on
set cursorline
set number

let g:solarized_termtrans=1
let g:solarized_termcolors=16
colorscheme solarized
set background=dark

let g:acp_enableAtStartup = 0
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_auto_completion_start_length = 1
if !exists('g:neocomplcache_force_omni_patterns')
	let g:neocomplcache_force_omni_patterns = {}
endif
let g:neocomplcache_force_omni_patterns.go = '.'
let g:neocomplcache_enable_fuzzy_completion = 1
let g:neocomplcache_fuzzy_completion_start_length = 1

"-----------------------------------------------------------------------------
"" NERD Tree Plugin Settings
"-----------------------------------------------------------------------------
"" Toggle the NERD Tree on an off with F7
nmap <F7> :NERDTreeToggle<CR>

" Close the NERD Tree with Shift-F7
nmap <S-F7> :NERDTreeClose<CR>

" Show the bookmarks table on startup
let NERDTreeShowBookmarks=1
