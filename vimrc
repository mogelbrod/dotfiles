" {{{ Home directory and swap files

  if has('win32') || has ('win64')
    let $VIMHOME = $HOME."\\vimfiles"
    set noswapfile
  else
    let $VIMHOME = $HOME."/.vim"
    set directory=$VIMHOME/swap//,.
    set backupdir=$VIMHOME/backup//,.
  endif

" }}}
" {{{ Basic settings and environment setup

  " Include plugins and stuff via pathogen
  call pathogen#infect()

  filetype plugin indent on
  syntax on
  colorscheme mogelbrod
  let mapleader = ","

  " Use Unicode and Unix linebreaks
  set termencoding=utf-8 encoding=utf-8 fileformat=unix

  " Language settings
  let $LANG='en'
  set langmenu=en helplang=en

  " Clipboard yanking
  if has('unnamedplus')
    set clipboard=unnamedplus
  else
    set clipboard=unnamed
  end

  " Tabs expand to 2 spaces
  set tabstop=2 shiftwidth=2 softtabstop=2 expandtab shiftround

  set tags=./.tags;/,.tags,./tags,tags " tag files

  " Buffer saving/reading
  set nobackup nowritebackup " do not create backups when writing to files
  set autoread " automatically reload file after external write
  set autowrite " autosave before making
  set hidden " allow switching of buffers without saving them first

  " UI elements / text appearance
  set lazyredraw
  set autoindent
  set cursorline nocursorcolumn " highlight line but not column
  set nonumber
  set wrap linebreak " word wrap
  set display=lastline " show as much as possible of the last line
  set scrolloff=3 " minimum number of lines surrounding cursor
  set listchars=tab:°\ ,trail:· " whitespace visible on :set list
  set diffopt+=iwhite " ignore whitespace when diffing
  set splitbelow splitright " push new splits to bottom/right

  " Search / highlight / replace
  set nojoinspaces
  set incsearch " show search results while being typed
  set hlsearch " highlight matches
  set smartcase "noignorecase
  set shellslash " always use forward slashes, even on windows

  " Command line
  set laststatus=2 " always show status line
  set showcmd " show incomplete commands
  set history=100 " command line history length
  set shellslash " always use forward slashes, even on windows
  set wildmenu
  set wildmode=list:longest,full
  set wildignore=*.o,*.bak,*.swc,*.swp,.git/*,.gitkeep,*.class
  set wildignore+=*/tmp/*,*.so,*.zip
  set wildignore+=tmp\*,*.zip,*.exe

  " What to scan for in insert mode completion
  set complete=.,w,b,u,t,i,k
  " Insert the longest common text, show menu for one result too
  set completeopt=longest,menu ",menuone

  " Statusline: %f(ile) [flags] {align} [%ft] %col %line/%total %percent
  "set ruler " overwritten below
  set statusline=%<\ %-f\ \ %m%r%h%w\ %=%y\ %4(%v%)\ %10(%l/%L%)\ \ %P

  " Shorten various messages in vim
  set shortmess=filnxoOtTI

  if has("balloon_eval")
    set noballooneval " disable annoying window popups
  endif

  " Disable bee/bell
  set noerrorbells visualbell t_vb=
  autocmd GUIEnter * set visualbell t_vb=

" }}}
" {{{ Buffer navigation

  " Ctrl+Left/right switches between buffers
  noremap <C-Left> :bprevious<CR>
  noremap <C-Right> :bnext<CR>
  noremap [D :bprevious<CR>
  noremap [C :bnext<CR>
  noremap [1;5D :bprevious<CR>
  noremap [1;5C :bnext<CR>

" }}}
" {{{ Command mode 

  " Quick shortcut for entering command mode
  noremap - :

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
  cnoreabbrev w!! %!sudo tee > /dev/null %

" }}}
" {{{ Key behaviour & custom mappings

  " Navigate through displayed lines, not physical
  nmap <silent> j gj
  nmap <silent> k gk
  imap <silent> <Down> <C-o>gj
  imap <silent> <Up> <C-o>gk
  nmap <silent> <Down> gj
  nmap <silent> <Up> gk
  "map <silent> <Up> <nop>
  "map <silent> <Down> <nop>
  "map <silent> <Left> <nop>
  "map <silent> <Right> <nop>

  " Scroll screen with <C-j>/<C-k>
  nmap <silent> <C-k> <C-e>
  nmap <silent> <C-j> <C-y>
  imap <silent> <C-j> <C-x><C-e>
  imap <silent> <C-k> <C-x><C-y>

  " Allow backspacing over everything
  set backspace=indent,eol,start

  " Have the cursor keys wrap between lines (like <Space> and <BkSpc> do)
  set whichwrap=<,>,[,]

  "nnoremap <F2> :set invpaste paste?<CR>
  nnoremap <F2> :set paste<CR>i
  " F2 toggles pasting mode
  set pastetoggle=<F2>
  " Disable paste after leaving insert mode
  au InsertLeave * set nopaste

  " F3 toggles highlighting of search results
  noremap <F3> :set hls!<CR>
  inoremap <F3> <C-o>:set hls!<CR>

  " F5 toggle Gundo plugin
  nnoremap <F4> :GundoToggle<CR>

  " Map Ctrl-< (lt) to surround plugin
  imap <silent>  <Plug>Isurround

  " Ctrl+H replaces all occurences of the selected text with something else
  vnoremap <C-h> "hy<Esc>:call ReplaceSelection()<CR>
  fun! ReplaceSelection()
    let replacement = input("Replacement for ".@h.": ")
    exe "%s~".escape(@h, '~').'~'.replacement.'~gc'
  endfun

  " Map P to replace selection without overwriting any registers
  vnoremap P "_dP

  " Map gp to select the last pasted (or changed) text
  nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

  noremap § <C-]>
  noremap <C-w>§ <C-w>}

" }}}
" {{{ Leader mappings

  " Tab manipulation
  noremap <silent> <leader>tn :tabnew<CR>
  noremap <silent> <leader>tc :tabclose<CR>
  noremap <silent> <leader>tm :tabmove<Space><C-r>=Input("New position")<CR><CR>
  " Tab switching with <leader>number
  noremap <silent> <leader>1 1gt
  noremap <silent> <leader>2 2gt
  noremap <silent> <leader>3 3gt
  noremap <silent> <leader>4 4gt
  noremap <silent> <leader>5 5gt
  noremap <silent> <leader>6 6gt
  noremap <silent> <leader>7 7gt
  noremap <silent> <leader>8 8gt
  noremap <silent> <leader>9 9gt

  " Copy buffer contents to clipboard
  map <silent> <leader>ya ggVG"+y''
  " Yank everything on the current side of a = character
  map <silent> <leader>ys <Esc>:call YankSide()<CR>

  " Fold navigation
  map <silent> <Leader><Up> [z
  map <silent> <Leader><Down> ]z

  " Toggle Indent guides
  nmap <silent> <leader>i <Plug>IndentGuidesToggle

  " Join visual selection lines with commas
  vmap <silent> <leader>j "hy:let @h=join(split(@h, "\n"), ", ")<CR>gv"hp

  " Expand tabs to spaces in selection
  vmap <leader>e :s#\t#\=repeat(" ", &l:ts)#g<CR>
  nmap <leader>e :%s#\t#\=repeat(" ", &l:ts)#g<CR>

  " Strip trailing whitespace
  nmap <leader>$ :call Preserve("%s/\\s\\+$//e")<CR>

  " Re-indent file
  nmap <leader>= :call Preserve("normal gg=G")<CR>

  nmap <leader>p :CtrlP <C-r>=expand('%:p:h')<CR><CR>

  " Tabular plugin map
  nmap <leader><space> :Tabularize /
  vmap <leader><space> :Tabularize /

  " Search for selection and replace with input() in all open buffers
  vmap <leader>h "hy:bufdo! %s~\V<C-r>h~~ge<left><left><left>

  noremap <leader>m :Make<space>
  noremap <leader>c :Make<CR>

  " Change directory to current buffer path
  nmap <leader>d :cd %:p:h<CR>

  map <leader>sh <Esc>:call HexToRGB()<CR>

  " Open / reload vimrc
  nmap <silent> <leader>V :e $MYVIMRC<CR>:filetype detect<CR>
  nmap <silent> <leader>v :source $MYVIMRC<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" }}}
" {{{ Folding

  " Folding (by braces)
  set foldmethod=marker foldmarker={{{,}}}

  " What actions should cause folds to open?
  set foldopen=insert,hor,block,hor,mark,percent,quickfix,search,tag,undo

  " Control fold open/closed with <Space>
  nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>

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
    let line = indentation . line . ' '

    " Line count
    if linecount == -1
      let linecount = ''
    else
      let linecount = ' '. linecount .  ' lines | ' . v:foldlevel
    end
    
    let cols = winwidth(0) - (&nu ? &numberwidth : 0)

    let fill = repeat('-', cols - strlen(line) - strlen(linecount))
    let line = strpart(line, 0, cols - strlen(linecount)) . fill . linecount

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
" {{{ Tabs

  if exists('+showtabline')
    function! MyTabLine()
      let s = ''
      let t = tabpagenr()
      let i = 1
      while i <= tabpagenr('$')
        let buflist = tabpagebuflist(i)
        let winnr = tabpagewinnr(i)
        let bufnr = buflist[winnr - 1]
        let file = bufname(bufnr)
        let buftype = getbufvar(bufnr, 'buftype')

        let s .= '%' . i . 'T' " tells vim which tab to show if clicked
        let s .= (i == t ? '%1*%#TabNumSel#' : '%2*%#TabNum#')
        let s .= ' ' . i " tab number

        if getbufvar(bufnr, '&modified')
          let s .= '+' " tab has modified contents
        endif
        let s .= ' %*'

        " Tab name
        let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#') " highlight group
        if buftype == 'nofile'
          if file =~ '\/.'
            let file = substitute(file, '.*\/\ze.', '', '')
          endif
        else
          let file = fnamemodify(file, ':p:t')
        endif
        if file == ''
          let file = '[NoName]'
        endif
        let s .= file . ' '

        let i = i + 1
      endwhile

      let s .= '%T%#TabLineFill#%='
      let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')

      return s
    endfunction

    set tabline=%!MyTabLine()
    set showtabline=1
  endif

" }}}
" {{{ (Re)formatting

  " Using Tab and Shift-Tab to (un)indent
  nmap <Tab> >>
  nmap <S-Tab> <<
  nmap [Z <<
  vmap <Tab> >gv
  vmap <S-Tab> <gv
  vmap [Z <gv

  " Formatting options (disable autocommenting)
  set formatoptions-=cro
  autocmd FileType * setlocal formatoptions-=cro

  " Do not reindent lines with a comment sign (removed 0#)
  autocmd FileType * setlocal cinkeys=0{,0},0),:,!^F,o,O,e

" }}}
" {{{ Plugins

  " SuperTab mappings
  let g:SuperTabMappingForward  = '<tab>'
  if has("gui_running")
    let g:SuperTabMappingBackward = '<s-tab>'
  else
    let g:SuperTabMappingBackward = '[Z'
  end
  " Alternate completion types
  imap <C-Space> <C-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<CR>
  imap <C-@> <C-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<CR>
  imap <C-a> <C-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<CR>
  imap <C-l> <C-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-l>")<CR>
  imap <C-f> <C-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-f>")<CR>

  " SuperTab options
  let g:SuperTabDefaultCompletionType = "<C-n>"
  let g:SuperTabLongestHighlight = 1

  " Snipmate-plus (comment out mappings in snipmate-plus/after/plugin)
  "inoremap <silent> <C-s> <c-r>=TriggerSnippet()<cr>
  "snoremap <silent> <C-s> <esc>i<right><c-r>=TriggerSnippet()<cr>
  let g:snips_author = "Victor Hallberg"

  " CtrlP plugin
  map <C-p> :CtrlP<CR>
  map <C-b> :CtrlPBuffer<CR>
  " search for both files, buffers and MRUs
  let g:ctrlp_cmd = 'CtrlPMixed'
  let g:ctrlp_switch_buffer = 1 " jump to existing buffers in same tab
  let g:ctrlp_max_depth = 10
  let g:ctrlp_open_new_file = 'ra'
  let g:ctrlp_mruf_max = 50
  let g:ctrlp_lazy_update = 200
  let g:ctrlp_extensions = ['mixed', 'tag']
  let g:ctrlp_reuse_window = 'netrw\|quickfix'

  let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v\.(git|hg|svn)$',
    \ 'file': '\v\.(exe|so|dll|tar|bz2|gz|zip|jar|deb|jpe?g|png|gif|bmp|mp3|avi|mp4|mov|mpe?g|mkv|pdf)$'
    \ }

  " Auto-Pairs
  let g:AutoPairsMapSpace = 0
  let g:AutoPairsCenterLine = 0
  let g:AutoPairsShortcutJump = '<c-s>'
  let g:AutoPairsShortcutFastWrap = '<c-b>' " default conflicts with å character

  " ZenCoding
  let g:user_zen_expandabbr_key = '<C-y><cr>'
  let g:user_zen_next_key = '<C-y>n'
  let g:user_zen_prev_key = '<C-y>p'
  let g:user_zen_balancetaginward_key = '<C-y>i'
  let g:user_zen_balancetagoutward_key = '<C-y>a'
  let g:user_zen_removetag_key = '<C-y>d'
  let g:user_zen_togglecomment_key = '<C-y>c'
  let g:user_zen_codepretty_keya = '<C-y>C'
  let g:user_zen_anchorizeurl_key = '<C-y>l'
  let g:user_zen_anchorizesummary_key = '<C-y>L'

  " NERDtree
  map <F5> :NERDTreeToggle<CR>
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
  endif

  " Syntastic
  let g:syntastic_check_on_open = 0
  let g:syntastic_echo_current_error = 1
  let g:syntastic_enable_signs = 0
  let g:syntastic_enable_highlighting = 0
  let g:syntastic_auto_jump = 0
  let g:syntastic_auto_loc_list = 1
  let g:syntastic_loc_list_height = 4
  let g:syntastic_mode_map = { 'mode': 'active',
        \ 'active_filetypes': [],
        \ 'passive_filetypes': ['java'] }

  " Indent guides
  let g:indent_guides_start_level = 2
  let g:indent_guides_guide_size = 1
  let g:indent_guides_color_change_percent = 5

" }}}
" {{{ Custom functions

  " Make
  command! -nargs=* Make silent! make <args> | redraw! | botright cwindow 5

  " Update tags file using ctags executable
  command! -nargs=? Tags call GenerateTags(<args>)

  command! -nargs=* IndentFolds setlocal foldmethod=expr foldexpr=IndentationFoldExpr(v:lnum)

  command! -nargs=0 SnippetFile exe "sp $VIMHOME/bundle/snipmate-plus/snippets/".&ft.".snippets"

  " Helper function which can be used to prompt for input in mappings and macros
  " (call with <C-r>=Input("prompt")<CR>)
  function! Input(prompt)
    call inputsave()
    let text = input(a:prompt . ': ')
    call inputrestore()
    return text
  endfunction

  " Generate new tags file recursively from cwd or a specific path
  function! GenerateTags(...)
    let path = a:0 > 0 ? a:1 : getcwd()
    let path .= has("win32") ? "\\" : "/"
    let cmd = "ctags -f ".path.".tags --tag-relative=yes --exclude=.git --exclude=.svn"
    let langs = &ft
    let extra = ''

		if &ft == 'haml'
			let langs = 'ruby'
    elseif &ft == 'php'
      let extra = " --PHP-kinds=+ivcf \\
        \ --regex-PHP='/(abstract)?\\s+class\\s+([^ ]+)/\\2/c/' \\
        \ --regex-PHP='/(static|abstract|public|protected|private)\\s+function\\s+(\\&\\s+)?([^ (]+)/\\3/f/' \\
        \ --regex-PHP='/interface\\s+([^ ]+)/\\1/i/' \\
        \ --regex-PHP='/\\$([a-zA-Z_][a-zA-Z0-9_]*)/\\1/v/'"
    endif

		call system(cmd . " --languages=".langs . " -R ".path . extra)
    echo "Tags file generated at: " . path.".tags"
  endfunction

  " Display hex color under cursor as RGB combo
  function! HexToRGB(...)
    if a:0 > 0
      let str = a:1
    else
      let str = expand("<cword>")
    endif

    let parts = matchlist(str, '\c\v#?([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})')
    if len(parts) < 1
      echo "Word under cursor does not appear to be a hexcolor"
      return
    endif

    let out = "RGB[ "
    for i in range(1, 3)
      let out = out . printf("%d ", "0x" . parts[i])
    endfor

    echo out . "]"
  endfunction

  " Copy everything on current side of equals sign (=)
  function! YankSide()
    let line = getline('.')
    let cur_col = col('.') " cursor column
    let eq_col = match(line, '=') " equal sign column
    if eq_col < cur_col " we are on the right side
      let line = substitute(line, '^[^=]\+=\s*', '', '')
    elseif eq_col > cur_col " we are on the left side
      let line = substitute(line, '\s*=.\+', '', '')
    endif
    call setreg(&clipboard == 'unnamed' ? '*' : '"', line)
  endfunction

  function! Preserve(command)
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    execute a:command
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
  endfunction

" }}}
" {{{ GUI settings/overwrites

  if has("gui_running")
    if has("win32")
      " Editor font
      set guifont=ProFontWindows:h9
      map <leader>0 :set guifont=ProFontWindows:h9<CR>
      map <leader>+ :set guifont=ProFontWindows:h16<CR>
    endif

    set guioptions=

    " Window size
    if !exists("g:gui_window_size_applied")
      set columns=100 lines=50
      let g:gui_window_size_applied = 1
    endif

    " Line numbers
    set number numberwidth=5

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

  " Dictionary
  au FileType * exe('setl dict+='.$VIMHOME.'/dict/'.&filetype)

  " LaTeX
  augroup ft_latex
    au!
    au FileType *tex setlocal makeprg=pdflatex\ -file-line-error\ % errorformat=%f:%l:\ %m
    if has("win32")
      au FileType *tex noremap <buffer> <leader>o :make<CR>:silent ! start "1" "%:r.pdf"<CR>
    else
      au FileType *tex noremap <buffer> <leader>o :make<CR>:silent !evince %:r.pdf &<CR>
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
    "au FileType ruby let g:rubycomplete_buffer_loading = 1
    au FileType ruby let g:rubycomplete_rails = 1
    au FileType yaml,haml IndentFolds
  augroup END

  augroup ft_python
    au!
    au FileType python setlocal ts=4 sts=4 sw=4
    au FileType python noremap <buffer> <leader>o :!python %<CR>
    au FileType python setlocal makeprg=python\ %
    au FileType python setlocal efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
    au FileType python call SuperTabSetDefaultCompletionType("<c-x><c-o>")
  augroup END

  " HTML
  augroup ft_html
    au!
  augroup END

  " CSS
  augroup ft_css
    au!
    " Split definitions into separate lines with ,j (inverse of J)
    au FileType css vmap <buffer> <leader>j :s/\([{;]\)\s*\n\?\s*/\1\r  /ge<BAR>:nohl<CR><<
    au FileType css setlocal sts=2 ts=2 sw=2 noexpandtab
  augroup END

  " XML
  au FileType xml IndentFolds

  " Markdown
  augroup ft_md
    au!
    if has("unix")
      au FileType markdown setlocal dictionary+=/usr/share/dict/words
    endif
    au FileType markdown setlocal infercase
  augroup END

  " C++
  augroup ft_cpp
    au!
    "au FileType cpp setlocal foldmarker={,}
    if has("win32")
      au FileType c,cpp,h setlocal makeprg=mingw32-make
    else
      au FileType c,cpp,h setlocal makeprg=make
    endif
  augroup END

  augroup ft_php
    au!
    au BufRead,BufNewFile *.php,*.inc set ft=php.html
    au FileType php.html setlocal sts=2 ts=2 sw=2 noexpandtab
    au FileType php.html setlocal omnifunc=phpcomplete#CompletePHP
  augroup END

  " Lua
  "au FileType lua setlocal tabstop=2 shiftwidth=2

  " Java
  augroup ft_java
    au!
    au FileType java setlocal makeprg=ant\ -e\ -find
  augroup END
  let java_highlight_functions="style"

  " Help files
  au FileType help nmap <buffer> <CR> <C-]>

  " XQuery
  au FileType xquery setlocal makeprg=xqilla\ %

  " Matlab
  au FileType matlab setlocal makeprg=octave\ %

  " Snippets
  au FileType snippet setlocal noexpandtab

" }}}
