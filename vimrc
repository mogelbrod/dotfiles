filetype on
filetype plugin on
filetype indent on

" Map leader
let mapleader = ","

" Home directory and swap files
if has('win32') || has ('win64')
	let $VIMHOME = $VIMRUNTIME
	set noswapfile
else
	let $VIMHOME = $HOME."/.vim"
	set backupdir=~/.vim/backup
	set directory=~/.vim/swap
endif

" Include plugins and stuff via pathogen
call pathogen#infect()

" Enable syntax highlighting
if &t_Co > 2 || has("gui_running")
  syntax on
endif

colorscheme mogelbrod

set autowrite " autosave before making

" {{{ Basic settings

" Language settings
let $LANG='en'
set langmenu=en
set helplang=en

" Use Unicode and Unix linebreaks
set termencoding=utf-8
set encoding=utf-8
set fileformat=unix

set clipboard=unnamed " yank to system clipboard
set autoindent

" Display guides & line numbers
set ruler
set nocursorline nocursorcolumn
set nonumber

set lazyredraw

" Allow switching of buffers without saving them first
set hidden

set wrap linebreak " word wrap

set listchars=tab:·\ ,trail:° " whitespace visible on :set list
set diffopt+=iwhite " ignore whitespace when diffing

set incsearch " Show search results while being typed
set hlsearch " Highlight matches
set ignorecase "smartcase "noignorecase

set showcmd " show incomplete commands
set history=50 " command line history length

" Show as much as possible of the last line instead of @-lines
set display=lastline
" Minimum number of lines surrounding cursor
set scrolloff=3

" Tabs
set tabstop=2
set shiftwidth=2
set shiftround

" Highlighting of matching braces
set matchpairs=(:),{:},[:]

set laststatus=2 " always show status line

" Statusline: %f(ile) [flags] {align} [%ft] %col %line/%total %percent
set statusline=%<\ %-f\ \ %m%r%h%w\ %=%y\ %4(%v%)\ %10(%l/%L%)\ \ %P

" Shorten various messages in vim
set shortmess=filnxoOtTI

" }}}
" {{{ Buffer navigation

" Ctrl+Left/right switches between buffers
noremap <C-Left> :bprevious<CR>
noremap <C-Right> :bnext<CR>
noremap [D :bprevious<CR>
noremap [C :bnext<CR>
noremap [1;5D :bprevious<CR>
noremap [1;5C :bnext<CR>

" CtrlP plugin
" search for both files, buffers and MRUs
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_switch_buffer = 1 " jump to existing buffers in same tab
let g:ctrlp_max_depth = 10
let g:ctrlp_open_new_file = 'r'
let g:ctrlp_mruf_max = 50
let g:ctrlp_extensions = ['mixed']

" SelectBuf plugin
"nmap <silent> <C-Tab> <Plug>SelectBuf
"imap <silent> <C-Tab> <ESC><Plug>SelectBuf
nmap <F5> <Plug>SelectBuf
imap <F5> <ESC><Plug>SelectBuf
let g:selBufUseVerticalSplit = 1

" }}}
" {{{ Command mode 

" Quick shortcut for entering command mode
nnoremap - :
vnoremap - :

" Usable bindings
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap  <Home>
cnoremap  <End>
" Ctrl-Arrow word jump
cnoremap [D <S-Left>
cnoremap [C <S-Right>

" Alias capital W to write
cnoreabbrev W w

" Add :w!! command which will write file as sudo
cmap w!! %!sudo tee > /dev/null %

" Completion
set wildmenu
set wildmode=longest,list,full
set wildignore=*.o,*.bak,*.swc,*.swp,.git/*,.gitkeep
set wildignore+=*/tmp/*,*.so,*.zip
set wildignore+=tmp\*,*.zip,*.exe
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.hg$\|\.svn$',
  \ 'file': '\.exe$\|\.so$\|\.dll$'
	\ }

" }}}
" {{{ Key behaviour & custom mappings

" kj as alternative to <Esc> in insert mode
inoremap kj <Esc>

" Navigate through displayed lines, not physical
imap <silent> <Down> <C-o>gj
imap <silent> <Up> <C-o>gk
nmap <silent> <Down> gj
nmap <silent> <Up> gk

" Scroll screen with <C-arrows>
nmap <silent> <C-Down> <C-e>
nmap <silent> <C-Up> <C-y>
imap <silent> <C-Down> <C-x><C-e>
imap <silent> <C-Up> <C-x><C-y>

" Scroll with Space in normal mode
noremap <S-space> <C-b>
noremap <space> <C-f>

" Allow backspacing over everything
set backspace=indent,eol,start

" Have the cursor keys wrap between lines (like <Space> and <BkSpc> do)
set whichwrap=h,l,<,>,[,]

" F2 toggles pasting mode
set pastetoggle=<F2>
nnoremap <F2> :set invpaste paste?<CR>

" F3 toggles highlighting of search results
noremap <F3> :set hls!<CR>

" Fold navigation
map <silent> <Leader><Up> zk
map <silent> <Leader><Down> zj

" Tag jumping
map <silent> <Leader>t <C-]>

" Change directory to current buffer path
noremap <leader>d :cd %:p:h<CR>

" Bindings to open vimrc and to reload vimrc
map <leader>V :args $MYVIMRC<CR>
map <silent> <leader>v :source $MYVIMRC<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" Map Ctrl-< (lt) to surround plugin
" Surround plugin also allows <C-s><CR>< to create multi-line tag
imap <silent>  <C-s><

" Ctrl-L inserts =>
imap  <space>=><space>
imap <C-L> <space>=><space>

" }}}
" {{{ Folding

" Folding (by braces)
set foldmethod=marker foldmarker={{{,}}}

" Fold text (title)
function! CustomFoldText(...) " {{{
	if a:0 > 0
		let line = a:1
		let linecount = a:0 > 1 ? a:2 : -1
	else
		let line = getline(v:foldstart)
		let linecount = v:foldend - v:foldstart + 1
	endif

	" Store indentation and later re-apply it
	let spaces4tab = repeat(' ', &l:ts)
	let indentation = substitute(matchstr(line, '^\s*'), "\t", spaces4tab, 'g')

	" Remove fold marker if present
	let foldmarkers = split(&foldmarker, ',')
	let line = substitute(line, '\V' . foldmarkers[0] . '\%(\d\+\)\?', '', '')

	" Remove known comment strings
	let comment = split(&commentstring, '%s')
	if comment[0] != ''
		let comment_begin = comment[0]
		let comment_end = ''
		if len(comment) > 1
			let comment_end = comment[1]
		end
		let pattern = '\V' . comment_begin . '\s\*' . comment_end . '\s\*\$'
		if line =~ pattern
			let line = substitute(line, pattern, '', '')
		else
			let line = substitute(line, '\V' . comment_begin, '', '')
			if comment_end != ''
				let line = substitute(line, '\V' . comment_end, '', '')
			endif
		endif
	endif

	" Remove additional comment prefixes
	if &ft=='cpp' || &ft=='php'
		let line = substitute(line, '\V//', '', '')
	endif

	" Remove any remaining leading/trailing whitespace
	let line = substitute(line, '^\s*\(.\{-}\)\s*$', '\1', '') . ' '

	" Reapply indentation
	let line = indentation . line

	" Line count
	if linecount == -1
		let linecount = ''
	else
		let linecount = ' '. linecount .  ' lines | ' . v:foldlevel
	end

	let fill = repeat('-', &columns - strlen(line) - strlen(linecount))
	let line = strpart(line, 0, &columns - strlen(linecount)) . fill . linecount

	return line
endfunction " }}}
set foldtext=CustomFoldText()

function! IndentationFoldExpr(ln) " {{{
	let line = getline(a:ln)

	if line =~ '^\s*$'
		return '-1' "'='
	end

	let ind = indent(a:ln) / &sw
	let ind_next = indent(nextnonblank(a:ln+1)) / &sw

	if ind_next <= ind
		return ind
	elseif ind_next > ind
		return '>'.ind_next
	end
endfunction " }}}

" }}}
" {{{ (Re)formatting

" Using Tab and Shift-Tab to (un)indent
nmap <Tab> >>
nmap <S-Tab> <<
nmap [Z <<
vmap <Tab> >gv
vmap <S-Tab> <gv
vmap [Z <gv

" Expand tabs to spaces in selection
vmap <leader>e :s#\t#\=repeat(" ", &l:ts)#g<CR>

" Formatting options (disable autocommenting)
set formatoptions-=cro
autocmd FileType * setlocal formatoptions-=cro

" Do not reindent lines with a comment sign (removed 0#)
autocmd FileType * setlocal cinkeys=0{,0},0),:,!^F,o,O,e

" }}}
" {{{ Search and replace

" Ctrl+H replaces all occurences of the selected text with something else
vnoremap <C-h> "hy<Esc>:call ReplaceSelection()<CR>
fun! ReplaceSelection()
	let replacement = input("Replacement for ".@h.": ")
	exe "%s~".escape(@h, '~').'~'.replacement.'~gc'
endfun

" Search for <cword> and replace with input() in all open buffers
map <leader>h "hy:bufdo! %s~\V<C-r>h~~ge<left><left><left>

" }}}
" {{{ Completion

" Insert the longest common text, show menu for one result too
set completeopt=longest,menu ",menuone

" Add some expected functionality to some keys when the completion menu is visible
" SuperTab already does this
"inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
"inoremap <expr> <Down> pumvisible() ? "\<C-n>" : "\<Down>"
"inoremap <expr> <Up> pumvisible() ? "\<C-p>" : "\<Up>"

" SuperTab mappings
if has("gui_running")
	let g:SuperTabMappingBackward = '<S-Tab>'
	let g:SuperTabMappingForward  = '<Tab>'
else
	let g:SuperTabMappingBackward = '[Z'
	let g:SuperTabMappingForward  = '<Tab>'
end

" SuperTab options
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextDefaultCompletionType = "<C-n>"
let g:SuperTabLongestHighlight = 1
"let g:SuperTabCrMapping = 0

" Completion shortcuts
inoremap <silent> <C-Space> <C-x><C-o>
inoremap <silent> <C-@> <C-x><C-o>
inoremap <silent>  <C-n>
inoremap <silent>  <C-x><C-f>

" Enable keyword (dictionary) completion
set complete+=k

" }}}
" {{{ Plugins

" Ctrl-P
map  :CtrlP<CR>

" NERDtree
map <F4> :NERDTreeToggle<CR>
let NERDTreeWinSize=26
let NERDTreeMinimalUI=1

" Tag list
map <F6> :TlistToggle<CR>
let Tlist_Compact_Format = 1
let Tlist_Enable_Fold_Column = 0
let Tlist_File_Fold_Auto_Close = 1
"let Tlist_Exit_OnlyWindow = 1
"let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Highlight_Tag_On_BufEnter = 0
let Tlist_Use_Right_Window = 1

if !has("gui_running")
	" Do not resize window when toggling tag list split
	let Tlist_Inc_Winwidth = 0
	" Fix bug introduced by AutoClose (arrow keys mapping to ABCD)
	let g:AutoClosePreservDotReg = 0
endif

" Syntastic
let g:syntastic_check_on_open = 0
let g:syntastic_echo_current_error = 1
let g:syntastic_enable_signs = 0
let g:syntastic_enable_highlighting = 0
let g:syntastic_auto_jump = 0
let g:syntastic_auto_loc_list = 1
let g:syntastic_loc_list_height = 4

" }}}
" {{{ Custom functions

function! RI_lookup(ruby_entity) " {{{
	let s:ri_result = system('ri "' . a:ruby_entity . '"')
	if match(s:ri_result, "More than one") != -1
		let s:header_and_result = split(s:ri_result, '\n\n')
		let s:result_as_list = split(substitute(substitute(s:header_and_result[1], '\n', '', 'g'), ' ', '', 'g'), ',')

		echo s:header_and_result[0]
		echo '---------------------------------------------------------'

		let s:index = 0
		for item in s:result_as_list
			echo '' . s:index . '  -  ' . item
			let s:index += 1
		endfor

		echo '---------------------------------------------------------'
		let s:user_selection = input('Specify choice by number: ')

		:redraw
		:call RI_lookup(s:result_as_list[str2nr(s:user_selection)])
	else
		echo s:ri_result
	endif
endfunction " }}}

command! -nargs=* Ri call RI_lookup(<q-args>)
au filetype ruby nn <buffer> K <Esc>:call<space>RI_lookup(expand('<cword>'))<CR>
au filetype ruby vn <buffer> K "xy<Esc>:call<space>RI_lookup(@x)<CR>

" Make
command! -nargs=* Make make <args> | cwindow 5
noremap <leader>m :Make<space>
noremap <leader>c :Make<CR>

" }}}
" {{{ GUI settings/overwrites

if has("gui_running")
	if has("win32")
		" Editor font
		set guifont=ProFontWindows:h9
		map <leader>0 :set guifont=ProFontWindows:h9<CR>
		map <leader>+ :set guifont=ProFontWindows:h16<CR>

		" Ctrl-C copies
		vmap <C-c> "+y
	endif

	" Toolbar
	set guioptions-=T

	" Window size
	set columns=100 lines=50

	" Line numbers
	set number numberwidth=5

	" Highlight current line
	set cursorline
	autocmd WinEnter * setlocal cursorline
	autocmd WinLeave * setlocal nocursorline

	" Cursor settings
	set guicursor=n-v-c-r:block-Cursor/lCursor-blinkon0
	set guicursor+=i-ci:ver25
	set guicursor+=r-i-ci:blinkwait900-blinkon600-blinkoff300
	set guicursor+=n:blinkwait900-blinkon600-blinkoff300

	set nomousehide
endif

" Enable mouse actions if possible
if has('mouse')
	set mouse=a
endif

" }}}
" {{{ Auto commands and file type specific options

" Disable paste after leaving insert mode
au InsertLeave * set nopaste

" Dictionary
au FileType * exe('setl dict+='.$VIMHOME.'/dict/'.&filetype)

" LaTeX
augroup ft_latex
	au!
	au FileType *tex setlocal makeprg=pdflatex\ -file-line-error\ % errorformat=%f:%l:\ %m
	if has("win32")
		au FileType *tex noremap <buffer> <leader>p :make<CR>:silent ! start "1" "%:r.pdf"<CR>
	else
		au FileType *tex noremap <buffer> <leader>p :silent !start evince %:r.pdf &<CR>
	endif
augroup END

" Ruby
augroup ft_ruby
	au!
	au FileType ruby,haml setlocal formatoptions=ql
	au FileType ruby setlocal makeprg=ruby\ -c\ $* errorformat=
		\%+E%f:%l:\ parse\ error,
		\%W%f:%l:\ warning:\ %m,
		\%E%f:%l:in\ %*[^:]:\ %m,
		\%E%f:%l:\ %m,
		\%-C%\tfrom\ %f:%l:in\ %.%#,
		\%-Z%\tfrom\ %f:%l,
		\%-Z%p^,
		\%-G%.%#
	" Expand <Ctrl-E> into #{_}
	au FileType ruby,haml inoremap <buffer>  #{}<left>
	"au FileType ruby let g:rubycomplete_buffer_loading = 1
	au FileType ruby let g:rubycomplete_rails = 1
	au FileType yaml,haml setlocal foldmethod=expr 
		\ foldexpr=IndentationFoldExpr(v:lnum)
augroup END

" HTML
augroup ft_html
	au!
	au FileType *html call SuperTabSetDefaultCompletionType("<c-x><c-o>")
	au FileType *html let b:SuperTabNoCompleteAfter = []
augroup END

" C++
augroup ft_cpp
	au!
	au FileType cpp setlocal foldmarker={,}
	if has("win32")
		au FileType cpp,h setlocal makeprg=mingw32-make
	else
		au FileType cpp,h setlocal makeprg=make
	endif
augroup END

" Lua
au FileType lua setlocal tabstop=2 shiftwidth=2

" Java
augroup ft_java
	au!
	au FileType java setlocal makeprg=ant\ -e\ -find
	au FileType java iabbrev <silent> <buffer> syso System.out.println()<left>
	au FileType java iabbrev <silent> <buffer> syse System.err.println()<left>
augroup END

" Help files
au FileType help nmap <buffer> <CR> <C-]>

" }}}
