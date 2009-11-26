" No backwards compability with vi
set nocompatible

" Language settings
let $LANG='en'
set langmenu=en
set helplang=en

" Use Unicode and Unix linebreaks
"let &termencoding = &encoding
set termencoding=utf-8
set encoding=utf-8
set fileformat=unix

set ignorecase smartcase

"============================
" Buffers 
"============================

" Allow switching of buffers without saving them first
set hidden

" Ctrl+Left/right switches between buffers
map [D :bprevious<CR>
map [C :bnext<CR>
map [1;5D :bprevious<CR>
map [1;5C :bnext<CR>

" List buffers with <F5>, and allow switching by using the corresponding number
noremap <F5> :buffers<CR>:buffer<Space>

"============================
" Command input and display
"============================

set history=50 " command line history length
set showcmd " show incomplete commands

set laststatus=2 " always show status line

"============================
" Key behavior
"============================

" Map leader
let mapleader = ","

" Enable mouse actions if possible
if has('mouse')
  set mouse=r
endif

set backspace=indent,eol,start
vnoremap <BS> d " backspace in visual mode deletes selection

" Navigate through displayed lines, not physical
imap <silent> <Down> <C-o>gj
imap <silent> <Up> <C-o>gk
nmap <silent> <Down> gj
nmap <silent> <Up> gk

" F3 toggles highlighting of search results
noremap <F3> :set hls!<CR>

" F4 toggles pasting mode
nnoremap <F4> :set invpaste paste?<CR>
imap <F4> <C-O><F4>
set pastetoggle=<F4>

" F7 copies selected text to system clipboard
vmap <F7> "+ygv"zy`>
vmap <C-y> "+ygv"zy`>

" Using Tab and Shift-Tab to (un)indent
map <Tab> >gv
map [Z <gv

" have the cursor keys wrap between lines (like <Space> and <BkSpc> do)
set whichwrap=h,l,<,>,[,]

" Ctrl+H replaces the selected text with something else
vnoremap <C-h> "hy:%s/<C-r>h//gc<left><left><left>

"============================
" Text display & guides
"============================

if has("gui_running")

	" Editor font
	set guifont=ProFontWindows:h9

	" Toolbar
	set guioptions-=T

	" Window size
	set columns=80
	set lines=40

	" Highlight current line
	set cursorline

endif

set ruler " show the cursor position all the time

" Word wrap
set wrap

" Line numbers
set numberwidth=4
"set nu

" Tabs
set tabstop=2 
set shiftwidth=2

" Minimum number of lines surrounding cursor
set scrolloff=3

" Show as much as possible of the last line instead of "@"-lines
set display=lastline

" Highlighting of matching braces
let g:loaded_matchparen=1 " disable
set matchpairs=(:),{:},[:]

" Fold
set foldmethod=marker

" Show search results while being typed
set incsearch

"============================
" Input
"============================

" Yank to system clipboard by default
set clipboard=unnamed 

filetype on
filetype plugin on
filetype indent on

" Indentation
"set autoindent
set nosmartindent autoindent
autocmd FileType * setlocal nosmartindent autoindent

" Formatting options (disable autocommenting)
set formatoptions-=cro
autocmd FileType * setlocal formatoptions-=cro

" Do not reindent lines with a comment sign (removed 0#)
autocmd FileType * setlocal cinkeys=0{,0},0),:,!^F,o,O,e

"============================
" Completion
"============================

" Inser the longest common text, show menu for one result too
set completeopt=longest,menuone

" Map Ctrl+Space to word completion 
inoremap <C-@> <C-x><C-u>

" Use the enter key to select an option when the menu is visible
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <Down> pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up> pumvisible() ? "\<C-p>" : "\<Up>"

" Control-W: Wrap selection with tag
source ~/.vim/scripts/wrapwithtag.vim

"============================
" Colors & syntax highlighting
"============================

" Enable syntax highlighting
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Select colorscheme
colorscheme mogelbrod

"============================
" File type specific
"============================

" Ruby
autocmd FileType ruby setlocal formatoptions=ql tabstop=2 shiftwidth=2 smarttab expandtab

" Lua
autocmd FileType lua setlocal tabstop=2 shiftwidth=2 

" Java
noremap <Leader>jc :set makeprg=javac\ %<CR>:make<CR>
noremap <Leader>jr :!echo %\|awk -F. '{print $1}'\|xargs java<CR>

