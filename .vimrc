set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'scrooloose/nerdtree'
Plugin 'altercation/vim-colors-solarized'
Plugin 'fatih/vim-go'
Plugin 'Valloric/YouCompleteMe'
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

" I want to hide buffer when go to another file instead of unloading it
set hidden

"-----------------------------------------------------------------------------
"" Custom shortcuts
"-----------------------------------------------------------------------------
" Edit the vimrc file
nmap <silent> ,ev :edit $MYVIMRC<CR>
nmap <silent> ,sv :source $MYVIMRC<CR>
" Go Back
nmap <silent> gb <C-o>
" Go forward
nmap <silent> gf <C-i>
" Quick save
nmap <silent> ,w :write<CR>
" Simple go to window shortcuts
nmap <silent> gh <C-w>h
nmap <silent> gj <C-w>j
nmap <silent> gk <C-w>k
nmap <silent> gl <C-w>l

"-----------------------------------------------------------------------------
"" NERD Tree Plugin Settings
"-----------------------------------------------------------------------------
"" Toggle the NERD Tree on an off with F7
nmap <F7> :NERDTreeToggle<CR>

" Close the NERD Tree with Shift-F7
nmap <S-F7> :NERDTreeClose<CR>

" Show the bookmarks table on startup
let NERDTreeShowBookmarks=1

" Change CWD when change NERDTree root
let NERDTreeChDirMode=2

"-----------------------------------------------------------------------------
"" vim-go plugin settings
"-----------------------------------------------------------------------------
au FileType go nmap gd <Plug>(go-def)
