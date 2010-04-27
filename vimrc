" No backwards compability with vi
set nocompatible

" {{{ Language and file encoding ===============================================

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

" }}}
" {{{ Buffer handling ==========================================================

" Allow switching of buffers without saving them first
set hidden

" Ctrl+Left/right switches between buffers
map [D :bprevious<CR>
map [C :bnext<CR>
map [1;5D :bprevious<CR>
map [1;5C :bnext<CR>
map <C-Left> :bprevious<CR>
map <C-Right> :bnext<CR>

" List buffers with <F5>, and allow switching by using the corresponding number
"noremap <F5> :buffers<CR>:buffer<Space>

" SelectBuf plugin
nmap <silent> <C-Tab> <Plug>SelectBuf
imap <silent> <C-Tab> <ESC><Plug>SelectBuf
nmap <silent> <F5> <Plug>SelectBuf
imap <silent> <F5> <ESC><Plug>SelectBuf
let g:selBufUseVerticalSplit = 1

" }}}
" {{{ Command input and display ================================================

set history=50 " command line history length
set showcmd " show incomplete commands

set laststatus=2 " always show status line

set shortmess=filnxtToOI

set nocursorline nocursorcolumn

" }}}
" {{{ Key behaviour ============================================================

" Map leader
let mapleader = ","

" Bindings to open vimrc and to reload vimrc
map <leader>v :sp $MYVIMRC<CR><C-W>_
map <silent> <leader>V :source $MYVIMRC<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

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
map <S-Tab> <gv
map [Z <gv

" have the cursor keys wrap between lines (like <Space> and <BkSpc> do)
set whichwrap=h,l,<,>,[,]


" Display possibly unwanted spaces
noremap <Leader>se / \+$
noremap <Leader>ss /^ \+

" }}}
" {{{ Text & display guides ====================================================

set ruler " show the cursor position all the time

set nonu

" Word wrap
set wrap linebreak

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

" }}}
" {{{ Input ====================================================================

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

" }}}
" {{{ Search and replace =======================================================

" Ctrl+H replaces the selected text with something else
vnoremap <C-h> "hy:%s/<C-r>h//gc<left><left><left>

" Search for <cword> and replace with input() in all open buffers
map <Leader>h "hy:bufdo! %s/<C-r>h//ge<left><left><left>

" Wrap visual selection in an HTML tag.
vmap <C-w> <Esc>:call VisualHTMLTagWrap()<CR>
function! VisualHTMLTagWrap()
  let tag = input("Tag to wrap block: ")
  if len(tag) > 0
    normal `>
    if &selection == 'exclusive'
      exe "normal i</".tag.">"
    else
      exe "normal a</".tag.">"
    endif
    normal `<
    exe "normal i<".tag.">"
    normal `<
  endif
endfunction

" }}}
" {{{ Completion ===============================================================

" Insert the longest common text, show menu for one result too
set completeopt=longest,menuone

" Add some expected functionality to some keys when the completion menu is visible
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <Down> pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up> pumvisible() ? "\<C-p>" : "\<Up>"

" Map Ctrl+Space to word completion 
"inoremap <C-@> <C-p> "<C-x><C-u>
"inoremap <C-Space> <C-p> "<C-x><C-u>

" SuperTab bindings for terminal
let g:SuperTabMappingForward = '<nul>'
let g:SuperTabMappingBackward = '<s-nul>'

" }}}
" {{{ Colors & syntax highlighting =============================================

" Enable syntax highlighting
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Select colorscheme
colorscheme mogelbrod

" }}}
" {{{ File type specific options ===============================================

" Compiling
command! -nargs=* Make make <args> | cwindow 5
noremap <Leader>m :Make 
noremap <Leader>c :Make<CR>
noremap <Leader>p :!pdflatex % && evince %:r.pdf &<CR>

" Ruby
autocmd FileType ruby setlocal formatoptions=ql tabstop=2 shiftwidth=2 smarttab expandtab

" Lua
autocmd FileType lua setlocal tabstop=2 shiftwidth=2 

" Java
autocmd FileType java setlocal makeprg=ant\ -e

" C++
autocmd FileType cpp setlocal makeprg=make foldmarker={,}

" }}}
" {{{ GUI settings/overwrites ==================================================

if has("gui_running")

	" Editor font
	set guifont=ProFontWindows:h9

	" Toolbar
	set guioptions-=T

	" Window size
	set columns=100
	set lines=50

	" Line numbers
	set numberwidth=5
	set nu

	" Highlight current line
	set cursorline
	autocmd WinEnter * setlocal cursorline
	autocmd WinLeave * setlocal nocursorline

	" Cursor settings
	set guicursor=n-v-c-r:block-Cursor/lCursor-blinkon0
	set guicursor+=i-ci:ver25
	set guicursor+=r-i-ci:blinkwait900-blinkon600-blinkoff300
	set guicursor+=n:blinkwait900-blinkon600-blinkoff300
	
	" SuperTab bindings for GUI
	let g:SuperTabMappingForward = '<C-Space>'
	let g:SuperTabMappingBackward = '<S-C-Space>'

	" Ctrl-C copies
	vmap <C-c> "+y

	" Disable swap files
	set noswapfile

	" Enable mouse actions if possible
	if has('mouse')
		set mouse=a
	endif

endif

" }}}
