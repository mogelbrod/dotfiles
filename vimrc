" {{{ Home directory and swap files

  let $VIMHOME = $HOME."/.vim"

  if has('win32') || has('win64')
    set runtimepath^=~/.vim
    set noswapfile
  else
    set directory=$VIMHOME/swap//,.
    set backupdir=$VIMHOME/backup//,.

    if has('mac')
      set noswapfile
    endif
  endif

  call has('python3')

  if empty(glob($VIMHOME . '/autoload/plug.vim'))
    silent !curl -fLo $VIMHOME/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif

" }}}
" {{{ Plugins

  call plug#begin($VIMHOME . '/bundle')

  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'nixprime/cpsm', { 'do': 'PY3=ON ./install.sh' }

  " Completion & snippets & linting
  Plug 'Valloric/YouCompleteMe', { 'do': 'python3 ./install.py --go-completer --ts-completer' }
  Plug 'Shougo/echodoc.vim'
  Plug 'SirVer/ultisnips'
  Plug 'neomake/neomake'
  " Plug 'tom-doerr/vim_codex'

  " Plug 'tpope/vim-apathy' " Disabled due to being incompatible with https://github.com/HerringtonDarkholme/yats.vim/issues/200
  Plug 'AndrewRadev/splitjoin.vim'
  Plug 'Konfekt/FastFold'
  Plug 'airblade/vim-gitgutter'
  Plug 'b4winckler/vim-angry'
  Plug 'beloglazov/vim-textobj-quotes'
  Plug 'chrisbra/matchit'
  Plug 'christoomey/vim-sort-motion'
  Plug 'godlygeek/tabular'
  Plug 'janko/vim-test'
  Plug 'jiangmiao/auto-pairs'
  Plug 'kana/vim-textobj-function'
  Plug 'kana/vim-textobj-user'
  Plug 'knsh14/vim-github-link'
  Plug 'majutsushi/tagbar'
  Plug 'michaeljsmith/vim-indent-object'
  Plug 'mogelbrod/vim-jsonpath'
  Plug 'nathanaelkane/vim-indent-guides'
  Plug 'pechorin/any-jump.vim'
  Plug 'prettier/vim-prettier', { 'do': 'npm install' }
  Plug 'rickhowe/diffchar.vim'
  Plug 'rizzatti/dash.vim'
  Plug 'rking/ag.vim'
  Plug 'romainl/vim-qf'
  Plug 'scrooloose/nerdcommenter'
  Plug 'scrooloose/nerdtree'
  Plug 'sjl/gundo.vim'
  Plug 'thinca/vim-textobj-function-javascript'
  Plug 'tpope/vim-abolish'
  Plug 'tpope/vim-dispatch'
  Plug 'tpope/vim-endwise'
  Plug 'tpope/vim-eunuch'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'
  Plug 'yssl/QFEnter'

  " Language specific plugins
  " Plug 'othree/javascript-libraries-syntax.vim'
  " Plug 'sheerun/vim-polyglot' " bundle of most popular file type plugins
  Plug 'HerringtonDarkholme/yats.vim'
  Plug 'MaxMEllon/vim-jsx-pretty'
  Plug 'amadeus/vim-xml'
  Plug 'chrisbra/csv.vim'
  Plug 'digitaltoad/vim-jade'
  Plug 'ekalinin/Dockerfile.vim'
  Plug 'elzr/vim-json'
  Plug 'fatih/vim-go'
  Plug 'heavenshell/vim-jsdoc'
  Plug 'jparise/vim-graphql'
  Plug 'mattn/emmet-vim'
  Plug 'octol/vim-cpp-enhanced-highlight'
  Plug 'othree/csscomplete.vim'
  Plug 'othree/html5.vim'
  Plug 'pangloss/vim-javascript'
  Plug 'stephpy/vim-yaml'
  Plug 'tpope/vim-git'
  Plug 'vim-jp/vim-cpp'

  call plug#end()

" }}}
" {{{ Basic settings and environment setup

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

  " Don't show active mode in status line
  set noshowmode

  " Tabs expand to 2 spaces
  set tabstop=2 shiftwidth=2 softtabstop=2 expandtab shiftround

  set tags=./.tags;/,.tags,./tags,tags " tag files

  " Buffer saving/reading
  set nobackup nowritebackup " do not create backups when writing to files
  set autowrite " autosave before making
  set hidden " allow switching of buffers without saving them first

  " UI elements / text appearance
  set autoindent
  set cursorline nocursorcolumn " highlight line but not column
  set nonumber
  set wrap linebreak " word wrap
  set display=lastline " show as much as possible of the last line
  set scrolloff=3 " minimum number of lines surrounding cursor
  set listchars=tab:°\ ,trail:·,nbsp:· " whitespace visible on :set list
  set diffopt+=iwhite " ignore whitespace when diffing
  set splitbelow splitright " push new splits to bottom/right
  set signcolumn=yes

  " Search / highlight / replace
  set nojoinspaces
  set incsearch " show search results while being typed
  set hlsearch " highlight matches
  set smartcase "noignorecase
  set shellslash " always use forward slashes, even on windows

  " Command line
  set history=1000 " command line history length
  set shellslash " always use forward slashes, even on windows
  set nowildmenu
  set wildmode=list:longest,full
  set wildignore=*.o,*.bak,*.swc,*.swp,.git/*,.gitkeep,*.class
  set wildignore+=*/tmp/*,*.so,*.zip
  set wildignore+=tmp\*,*.zip,*.exe

  " Insert mode completion
  set complete=.,w,t,i,k
  set completeopt=longest,menu
  if has('popupwin')
    set completeopt+=popup
    set completepopup=border:off,highlight:Pmenu ",align:flip
  end

  " Shorten various messages in vim
  set shortmess=filmnrxoOtTIc

  if has("balloon_eval")
    set noballooneval " disable annoying window popups
  endif

  " Disable bee/bell
  set noerrorbells visualbell t_vb=
  autocmd GUIEnter * set visualbell t_vb=

  " Timeouts (t = mappings, tt = keycodes)
  set timeout ttimeout timeoutlen=3000 ttimeoutlen=200

  " Update external program settings
  if executable('ag')
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g "" --ignore dist'
    let g:ctrlp_use_caching = 0
    let g:ag_prg = 'ag --nogroup --column --smart-case --ignore dist'
    set grepprg=ag\ --nogroup\ --nocolor\ --ignore\ dist
  elseif executable('ack')
    set grepprg=ack\ -k
  endif

  " Session management
  set sessionoptions=blank,buffers,tabpages,winsize,curdir,help

  " }}}
" {{{ Buffer navigation

" Ctrl+Left/right switches between buffers
noremap <C-Left> :bprevious<CR>
noremap <C-Right> :bnext<CR>
noremap [D :bprevious<CR>
noremap [C :bnext<CR>
noremap [1;5D :bprevious<CR>
noremap [1;5C :bnext<CR>

noremap <C-u> <C-i>
noremap <C-t> :b#<CR>

" }}}
" {{{ Command mode

" Quick shortcut for entering command mode
noremap - :
noremap ö :
noremap Ö :
noremap ; :

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

" Allow backspacing over everything
set backspace=indent,eol,start

" Have the cursor keys wrap between lines (like <Space> and <BkSpc> do)
set whichwrap=<,>,[,]

" Navigate through displayed lines, not physical
noremap <silent> j gj
noremap <silent> k gk
inoremap <silent> <Down> <C-o>gj
inoremap <silent> <Up> <C-o>gk
noremap <silent> <Down> gj
noremap <silent> <Up> gk

" Scroll screen with <C-j>/<C-k>
noremap <silent> <C-j> <C-d>
noremap <silent> <C-k> <C-u>

" Completion (C-x) key shortcuts
inoremap <C-l> <C-X><C-L>
inoremap <C-f> <C-X><C-F>

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

" F7 displays syntax highlighting info for token under cursor
noremap <F7> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
      \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
      \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Ctrl+H replaces all occurences of the selected text with something else
vnoremap <C-h> "zy<Esc>:call ReplaceSelection()<CR>
fun! ReplaceSelection()
  let replacement = input("Replacement for ".@z.": ")
  exe "%s~\\M".escape(@z, '[]~\').'~'.escape(replacement, '&').'~gc'
endfun

fun! JsArrowToFunction()
  s/\v(^|<const )\s*([a-zA-Z0-9_]+)\s*[=:]\s*\(?([^)>]{-})\)?\s*\=\>\s*\{/function \2(\3) {/
endfun

" Map P to replace selection without overwriting any registers
vnoremap P "_dP

" Map gp to select the last pasted (or changed) text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

noremap § <C-]>
noremap <C-w>§ <C-w>}

" Swap mark jump mappings
nnoremap ' `
nnoremap ` '

" Navigate quickfix
nnoremap ]p :cprev<CR>
nnoremap ]n :cnext<CR>
nnoremap ]P :cpfile<CR>
nnoremap ]N :cnfile<CR>

" Keep search matches in the middle of the window
nnoremap * *zzzv
nnoremap # #zzzv
nnoremap n nzzzv
nnoremap N Nzzzv

" }}} (
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

  nore <leader>g :call RecursiveGrepCommand() <Bar> cw<CR><CR><CR>
  nore <silent> <leader><leader>g <Esc>:Egrep ""<left>
  vnore <leader>g "zy:call RecursiveGrepCommand(@z) <Bar> cw<CR><CR><CR>

  nore <silent> <leader><leader>x TestFile

  " Copy buffer contents to clipboard
  map <silent> <leader>ya ggVG"+y''
  " Copy Git(Hub) permalink to current/selected line(s)
  nore <silent> <leader>yg :GetCommitLink<CR>
  " Yank everything on the current side of a = character
  nore <silent> <leader>ys <Esc>:call YankSide()<CR>

  " Fold navigation
  map <silent> <Leader><Up> [z
  map <silent> <Leader><Down> ]z

  " :cnext / :cprev
  map <silent> <Leader>[ :cprev<CR>
  map <silent> <Leader>] :cnext<CR>

  " Toggle Indent guides
  nmap <silent> <leader>i <Plug>IndentGuidesToggle

  nnoremap <leader>j :AnyJump<CR>
  xnoremap <leader>j :AnyJumpVisual<CR>

  " Join visual selection lines with commas
  " vmap <silent> <leader>j "zy:let @z=join(split(@z, "\n"), ", ")<CR>gv"zp

  " Expand tabs to spaces in selection
  vmap <leader>e :s#\t#\=repeat(" ", &l:ts)#g<CR>
  nmap <leader>e :%s#\t#\=repeat(" ", &l:ts)#g<CR>

  " Strip trailing whitespace
  nmap <leader>$ :call Preserve("%s/\\s\\+$//e")<CR>

  " Re-indent file
  nmap <leader>= :call Preserve("normal mzgg=G'z")<CR>

  nmap <leader>p :CtrlP <C-r>=expand('%:p:h')<CR><CR>
  nmap <leader>l :CtrlP ~/src/

  nmap <leader>a :Agext <C-r>=expand('%:e')<CR>

  " Comment toggling
  map <leader>7 <plug>NERDCommenterToggle
  vmap <leader>7 <plug>NERDCommenterToggle
  map <leader>/ <plug>NERDCommenterSexy
  vmap <leader>/ <plug>NERDCommenterSexy

  " Tabular plugin map
  nmap <leader><space> :Tabularize /
  vmap <leader><space> :Tabularize /

  " Search for selection and replace with input() in all open buffers
  vnoremap <leader>h "zy:bufdo! %s~\V<C-r>z~~ge<left><left><left>

  noremap <leader>m :Make<space>
  noremap <leader>c :Make<CR>

  noremap <leader>n :cn<CR>

  " Convert number(s) under cursor
  nore <leader>sd <Esc>:call DecToHex()<CR>
  vnore <leader>sd <Esc>:call DecToHex()<CR>
  nore <leader>sh <Esc>:call HexToRGB()<CR>

  " Open / reload vimrc
  nmap <silent> <leader>V :e $MYVIMRC<CR>:filetype detect<CR>
  nmap <silent> <leader>v :source $MYVIMRC<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" }}}
" {{{ (Re)formatting

  " Using Tab and Shift-Tab to (un)indent
  nore <tab> >>
  nore <S-tab> <<
  nore [Z <<
  vnore <tab> >gv
  vnore <S-tab> <gv
  vnore [Z <gv
  " Ensure UltiSnips doesn't override visual <tab>
  au BufEnter * vnoremap <tab> >gv

  " Formatting options (disable autocommenting)
  set formatoptions=rjnq1
  autocmd FileType * setlocal formatoptions-=co

  " Do not reindent lines with a comment sign (removed 0#)
  autocmd FileType * setlocal cinkeys=0{,0},0),:,!^F,o,O,e

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


    let fill = repeat('-', cols - strlen(substitute(line, '.', 'x', 'g'))  - strlen(linecount))
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
" {{{ Tabline

  " TODO: Loop through windows in each tab to determine most appropriate tab name
  " See https://github.com/webastien/vim-tabs/blob/master/plugin/tabs.vim
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
      " Don't show close X
      " let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')

      return s
    endfunction

    set tabline=%!MyTabLine()
    set showtabline=1
  endif

" }}}
" {{{ Statusline

  set laststatus=2 " always show status line
  set showcmd " show incomplete commands
  " %f(ile) [flags] {align} [%ft] %col %line/%total %percent
  let g:statusline_mode={ 'n': 'N', 'no': 'Nop', 'v': 'Vis', 'V': 'Vln', '': 'Vbl', 's': 'Sel', 'S': 'Sln', '': 'Sbl', 'i': 'Ins', 'R': 'Rep', 'Rv': 'Rvr', 'c': 'Cmd', 'cv': 'vEX', 'ce': 'EX', 'r': 'Prompt', 'rm': 'More', 'r?': 'Confirm', '!': 'Shell' }

  if !has('nvim')
    function! MyStatusLine(active)
      let bufnr = winbufnr(g:statusline_winid)
      let st = ""
      let st .= "%< %-f  " " File path (truncated if necessary)
      let st .= "%m%r%w %="
      let st .= " %=" " Separation point
      if a:active
        " Show current mode in active window
        let st .= "%{g:statusline_mode[mode()]}  "
      endif
      let st .= neomake#statusline#get(bufnr, {
        \ 'format_running': '({{running_job_names}}) ',
        \ 'format_loclist_unknown': '',
        \ 'format_loclist_ok': '✓',
        \ 'format_quickfix_ok': '',
        \ 'format_quickfix_issues': '%s',
        \ })
      let st .= " %y " " File type
      let st .= "%4(%v%) %10(%l/%L%)  %P" " Colum & line numbers
      return st
    endfunction

    set statusline=%!MyStatusLine(1)
    augroup statusline
      au WinEnter * setlocal statusline=%!MyStatusLine(1)
      au WinLeave * setlocal statusline=%!MyStatusLine(0)
    augroup END
  endif

" }}}
" {{{ Plugin configuration

  " UltiSnips
  let g:UltiSnipsNoPythonWarning = 1
  let g:UltiSnipsEnableSnipMate = 0
  let g:UltiSnipsJumpForwardTrigger = '<c-j>'
  let g:UltiSnipsJumpBackwardTrigger = '<c-k>'
  function! UltiSnips_Complete()
    call UltiSnips#ExpandSnippet()
    if g:ulti_expand_res == 0
      return pumvisible() ? "\<c-n>" : "\<tab>"
    endif
    return ""
  endfunction
  augroup ultisnips
    au!
    au VimEnter * au! UltiSnips_AutoTrigger
    au BufEnter * inoremap <buffer> <silent> <tab> <C-R>=UltiSnips_Complete()<cr>
    au BufEnter * snoremap <buffer> <silent> <tab> <C-R>=UltiSnips_Complete()<cr>
  augroup END

  " YouCompleteMe / YCM
  let g:ycm_min_num_of_chars_for_completion = 2
  let g:ycm_min_num_identifier_candidate_chars = 1
  let g:ycm_seed_identifiers_with_syntax = 1
  let g:ycm_complete_in_comments = 1
  let g:ycm_autoclose_preview_window_after_insertion = 0
  let g:ycm_auto_hover = ''
  let g:ycm_error_symbol = '> '
  let g:ycm_warning_symbol = '! '
  let g:ycm_semantic_triggers = {
      \ 'javascript': [ 're!([ ;] |\t|: |@)' ],
      \ 'css,scss': [ '\t', '  ', '; ', ': ', '@' ],
      \ }
  let g:ycm_log_level = 'info'
  let g:ycm_key_detailed_diagnostics = ''

  " Any-jump
  let g:any_jump_search_prefered_engine = 'ag'
  let g:any_jump_window_width_ratio  = 0.8
  let g:any_jump_window_height_ratio = 0.8
  let g:any_jump_disable_default_keybindings = 1

  " EchoDoc
  let g:echodoc#enable_at_startup = 1

  " NeoMake
  call neomake#configure#automake('w')
  let g:neomake_open_list = 2
  let g:neomake_list_height = 6
  let g:neomake_place_signs = 1
  let g:neomake_highlight_columns = 0
  let g:neomake_javascript_enabled_makers = ['eslint']
  let g:neomake_typescript_enabled_makers = ['eslint']
  let g:neomake_graphql_enabled_makers = ['eslint']

  function! EslintInitForJob(jobinfo) dict abort
    let project_root = neomake#utils#get_project_root(a:jobinfo.bufnr)
    if !a:jobinfo.file_mode
      if empty(project_root)
        call add(self.args, '.')
      else
        call add(self.args, project_root)
      endif
    endif
    if !empty(project_root)
      let self.cwd = project_root
      let rc_path = project_root . '/.eslintrc'
      if filereadable(rc_path)
        let rc_path = rc_path
      elseif filereadable(rc_path . '.js')
        let rc_path = rc_path . '.js'
      elseif filereadable(rc_path . '.json')
        let rc_path = rc_path . '.json'
      elseif filereadable(rc_path . '.yml')
        let rc_path = rc_path . '.yml'
      endif
      call add(self.args, '--config=' . rc_path)
      if filereadable(project_root . '/.eslintignore')
        call add(self.args, '--ignore-path=' . project_root . '/.eslintignore')
      endif
    endif
  endfunction

  call neomake#config#set('ft.javascript.eslint.InitForJob', function('EslintInitForJob'))
  call neomake#config#set('ft.typescript.eslint.InitForJob', function('EslintInitForJob'))
  call neomake#config#set('ft.typescriptreact.eslint.InitForJob', function('EslintInitForJob'))
  call neomake#config#set('ft.graphql.eslint.InitForJob', function('EslintInitForJob'))
  
  " Configures neomake to use a project-local instance of a maker
  function! SetNeomakeExe(ft_maker, file)
    let bufvar = 'b:neomake_'.a:ft_maker.'_exe'
    let path = findfile(a:file, '.;')
    if path != ''
      let path = fnamemodify(path, ':p')
      exe 'let '.bufvar.' = "'.escape(path, '"').'"'
    else
      exe 'unlet! '.bufvar
    endif
  endfunction

  " vim-prettier
  noremap <leader>q :Prettier<CR>
  let g:prettier#autoformat_config_present = 1
  let g:prettier#exec_cmd_async = 1
  let g:prettier#config#semi = 'false'
  let g:prettier#config#single_quote = 'true'
  let g:prettier#config#trailing_comma = 'all'
  let g:prettier#config#jsx_bracket_same_line = 'false'

  " vim-qf
  let g:qf_loclist_window_bottom = 0

  " vim-test
  let g:test#strategy = 'neomake'
  let g:test#runner_commands = ['Mocha']
  let g:test#javascript#mocha#file_pattern = '\v(tests?/.*|.*\.(test|spec))\.(js|jsx|ts|tsx)$'

  " GitGutter
  let g:gitgutter_enabled = 0
  noremap <silent> <leader>u :GitGutterToggle<CR>

  " CtrlP plugin
  noremap <C-p> :CtrlP<CR>
  noremap <C-b> :CtrlPBuffer<CR>
  let g:ctrlp_cmd = 'CtrlP'
  let g:ctrlp_switch_buffer = '0'
  let g:ctrlp_open_new_file = 'r'
  let g:ctrlp_max_depth = 10
  let g:ctrlp_lazy_update = 100
  let g:ctrlp_types = ['fil', 'buf']
  let g:ctrlp_extensions = ['dir', 'tag']
  let g:ctrlp_reuse_window = 'netrw'
  let g:ctrlp_mruf_relative = 1
  let g:ctrlp_mruf_max = 0 " attempt to disable MRU, just annoying in mixed mode
  let g:ctrlp_match_current_file = 1
  let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v\.(git|hg|svn)$',
    \ 'file': '\v\.(exe|so|dll|tar|bz2|gz|zip|jar|deb|jpe?g|png|gif|bmp|mp3|avi|mp4|mov|mpe?g|mkv|pdf)$'
    \ }
  let g:ctrlp_prompt_mappings = {
    \ 'PrtInsert("c")': ['<MiddleMouse>', '<insert>', '§', '<c-g>'],
    \ 'PrtInsert()': ['<c-y>'],
    \ }

  if !has("win32")
    let g:ctrlp_match_func = {'match': 'cpsm#CtrlPMatch'}
  endif

  " Auto-Pairs
  let g:AutoPairsMapSpace = 0
  let g:AutoPairsCenterLine = 0
  let g:AutoPairsMultilineClose = 0
  let g:AutoPairsShortcutJump = '<c-s>'
  let g:AutoPairsShortcutFastWrap = '<c-b>' " default conflicts with å character

  " splitjoin.vim
  let g:splitjoin_trailing_comma=1
  let g:splitjoin_html_attributes_bracket_on_new_line=1

  " Emmet
  let g:user_emmet_complete_tag = 1
  let g:user_emmet_leader_key = '<C-e>'
  imap <c-e><CR> <plug>(emmet-expand-abbr)
  " let g:user_emmet_next_key = '<C-e>n'
  " let g:user_emmet_prev_key = '<C-e>p'
  " let g:user_emmet_balancetaginward_key = '<C-e>i'
  " let g:user_emmet_balancetagoutward_key = '<C-e>a'
  " let g:user_emmet_removetag_key = '<C-e>d'
  " let g:user_emmet_togglecomment_key = '<C-e>c'
  " let g:user_emmet_codepretty_keya = '<C-e>C'
  " let g:user_emmet_anchorizeurl_key = '<C-e>l'
  " let g:user_emmet_anchorizesummary_key = '<C-e>L'
  let g:user_emmet_settings = {
  \  'javascript': { 'extends': 'jsx' },
  \  'typescript': { 'extends': 'jsx' },
  \}

  " Surround
  " For nr to use :echo char2nr("-"))
  let g:surround_13 = "{\n\t\r\n}" " enter
  let g:surround_40 = "(\n\t\r\n)" " (
  let g:surround_47 = "/*\n\r\n*/" " /
  let g:surround_102 = "<React.Fragment>\n\r\n</React.Fragment>" " f

  " NERDCommenter
  let g:NERDCreateDefaultMappings = 0
  let g:NERDSpaceDelims = 1

  " NERDtree
  map <F5> :NERDTreeToggle<CR>
  let g:NERDTreeWinSize = 26
  let g:NERDTreeMinimalUI = 1
  let g:NERDTreeMapActivateNode = 'l'
  let g:NERDTreeMapOpenRecursively = 'L'
  let g:NERDTreeMapChangeRoot = 'cd'
  let g:NERDTreeMapCWD = 'CD'
  let g:NERDTreeMapChdir = 'CW'

  " TagBar
  nnore <silent> <F6> :TagbarToggle<CR>
  let g:tagbar_autofocus = 1
  let g:tagbar_compact = 1
  let g:tagbar_expand = 0

  " Indent guides
  let g:indent_guides_start_level = 2
  let g:indent_guides_guide_size = 1
  let g:indent_guides_color_change_percent = 5

  " Misc
  let g:used_javascript_libs = 'jquery,react,requirejs'

  let g:vim_json_syntax_conceal = 0
  let g:yats_host_keyword = 0

  let g:jsdoc_enable_es6 = 1
  let g:jsdoc_underscore_private = 1

  let g:go_fmt_command = 'goimports'
  let g:go_highlight_functions = 1
  let g:go_highlight_function_parameters = 1
  let g:go_highlight_function_calls = 1
  let g:go_highlight_operators = 1
  let g:go_highlight_types = 1
  let g:go_highlight_fields = 0
  let g:go_highlight_variable_declarations = 1
  let g:go_highlight_variable_assignments = 1

  let g:gundo_prefer_python3 = 1

  let g:jsonpath_register = '*'
  let g:jsonpath_use_pyhon = 1

" }}}
" {{{ Custom functions and commands

  " Make
  command! -nargs=* -complete=file Make silent! make <args> | redraw! | botright cwindow 5

  " Update tags file using ctags executable
  command! -nargs=? Tags call GenerateTags(<args>) | cw

  command! -nargs=+ -complete=dir Agext call AgExt(<q-args>)
  command! -nargs=1 Egrep exe 'normal! :call RecursiveGrepCommand("'.<args>.'")<Bar> cw<CR><CR><CR>'

  command! -nargs=0 IFold setlocal foldexpr=IndentationFoldExpr(v:lnum) foldmethod=expr nofoldenable

  command! -nargs=1 Hex2RGB call HexToRGB(<args>)
  command! -nargs=1 Dec2Hex call DecToHex(<args>)

  command! -nargs=0 WipeHidden call WipeHiddenBuffers()

  command! -nargs=0 HiName echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"
  command! -nargs=0 ConcealTodo setlocal cole=2 <bar> call matchadd('Conceal', '/[*/] TODO: \zs.\{-}\ze\($\|\*/\)')

  command! -nargs=? -range=% Space2Tab call IndentConvert(<line1>,<line2>,0,<q-args>)
  command! -nargs=? -range=% Tab2Space call IndentConvert(<line1>,<line2>,1,<q-args>)
  command! -nargs=? -range=% RetabIndent call IndentConvert(<line1>,<line2>,&et,<q-args>)

  " Limit Ag command search to a specific file type
  function! AgExt(...) "{{{
    let words = split(a:1)
    let ext = words[0]
    let rest = join(words[1:-1], ' ')
    echo "normal :Ag -G '\.(".ext.")$' ".rest."<CR>"
    exe "Ag -G '\.(".ext.")$' ".rest
  endfunction "}}}

  " Generate new tags file recursively from cwd or a specific path
  function! GenerateTags(...) "{{{
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
  endfunction "}}}

  " External grep (recursive) on word under cursor or a given string
  function! RecursiveGrepCommand(...) "{{{
    if a:0 > 0
      let str = a:1
    else
      let str = expand("<cword>")
    endif

    if &grepprg == "ack -k" || match(&grepprg, "ag ") == 0
      let call = 'grep "'.str.'"'
    else
      let str = escape(str, '<>~.\*+[]^$')

      " TODO: don't add word boundary prefix/suffix when a word boundary character already starts/ends the string
      let filter = (expand("%:e") == '' ? '.' : '*.'.expand("%:e"))

      if has('win32') || has ('win64')
        " TODO: don't change grepprg on windows?
        set grepprg=findstr\ /spn
        let call = 'grep "\<'.str.'\>"'.filter
      else
        if len(filter) > 1
          let filter = '**/'.filter
        endif
        let call = 'grep -srnw --binary-files=without-match --exclude-dir=.git "\b'.str.'\b" '.filter
      endif
    endif

    exe call
  endfunction "}}}

  " Display hex color under cursor as RGB combo
  function! HexToRGB(...) "{{{
    if a:0 > 0
      let str = string(a:1)
    else
      let str = expand("<cword>")
    endif

    let parts = matchlist(str, '\c\v#?([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})')
    if len(parts) < 1
      echo "Word under cursor does not appear to be a hexcolor"
      return
    endif

    let out = "#".parts[1].parts[2].parts[3]." = RGB( "
    for i in range(1, 3)
      let out = out . printf("%d ", "0x" . parts[i])
    endfor

    echo out . ")"
  endfunction "}}}

  " Display the decimal number under cursor in hexadecimal format
  function! DecToHex(...) "{{{
    if a:0 > 0
      let str = string(a:1)
    else
      let str = expand("<cword>")
    endif

    let m = matchlist(str, '\c\v([0-9.]+)')
    if len(m) < 1
      echo "Word under cursor does not appear to be a decimal number"
      return
    endif

    echo printf("%s = 0x%x", m[1], m[1])
  endfunction "}}}

  " Copy everything on current side of equals sign (=)
  function! YankSide() "{{{
    let line = getline('.')
    let cur_col = col('.') " cursor column
    let eq_col = match(line, '=') " equal sign column
    if eq_col < cur_col " we are on the right side
      let line = substitute(line, '^[^=]\+=\s*', '', '')
    elseif eq_col > cur_col " we are on the left side
      let line = substitute(line, '\s*=.\+', '', '')
    endif
    call setreg(&clipboard == 'unnamed' ? '*' : '"', line)
  endfunction "}}}

  " Helper function which can be used to prompt for input in mappings and macros
  " (call with <C-r>=Input("prompt")<CR>)
  function! Input(prompt) "{{{
    call inputsave()
    let text = input(a:prompt . ': ')
    call inputrestore()
    return text
  endfunction "}}}

  function! Preserve(command) "{{{
    " Preparation: save last search, and cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    execute a:command
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
  endfunction "}}}

  function! WipeHiddenBuffers() "{{{
    let tpbl=[]
    let closed = 0
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
      if getbufvar(buf, '&mod') == 0
        silent execute 'bwipeout' buf
        let closed += 1
      endif
    endfor
    echo "Closed ".closed." hidden buffers"
  endfunction "}}}

  " Return indent (all whitespace at start of a line), converted from
  " tabs to spaces if what = 1, or from spaces to tabs otherwise.
  " When converting to tabs, result has no redundant spaces.
  function! Indenting(indent, what, cols) "{{{
    let spccol = repeat(' ', a:cols)
    let result = substitute(a:indent, spccol, '\t', 'g')
    let result = substitute(result, ' \+\ze\t', '', 'g')
    if a:what == 1
      let result = substitute(result, '\t', spccol, 'g')
    endif
    return result
  endfunction "}}}

  " Convert whitespace used for indenting (before first non-whitespace).
  " what = 0 (convert spaces to tabs), or 1 (convert tabs to spaces).
  " cols = string with number of columns per tab, or empty to use 'tabstop'.
  " The cursor position is restored, but the cursor will be in a different
  " column when the number of characters in the indent of the line is changed.
  function! IndentConvert(line1, line2, what, cols) "{{{
    let savepos = getpos('.')
    let cols = empty(a:cols) ? &tabstop : a:cols
    execute a:line1 . ',' . a:line2 . 's/^\s\+/\=Indenting(submatch(0), a:what, cols)/e'
    call histdel('search', -1)
    call setpos('.', savepos)
  endfunction "}}}

" }}}
" {{{ GUI settings/overwrites

  if has("gui_running")
    if has("win32")
      " Editor font
      set guifont=ProFontWindows:h9
      map <leader>0 :set guifont=ProFontWindows:h9<CR>
      map <leader>+ :set guifont=ProFontWindows:h16<CR>
    else
      set guifont=Monaco:h12
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
    if !has('nvim')
      set ttymouse=sgr
    endif
  endif

" }}}
" {{{ Auto commands and file type specific options

  augroup vimrc
    au!

    " Dictionary
    au FileType * exe('setl dict+='.$VIMHOME.'/dict/'.&filetype)

    au FileType qf setlocal nowrap
    au FileType qf nnoremap <silent> <buffer> q :q<CR>

    " Disable syntax highlighting for large files
    au BufWinEnter * if line2byte(line("$") + 1) > 1000000 | syntax clear | endif

    au FileType vim setlocal keywordprg=:help

    au FileType c,cpp,cs,javascript*,typescript*,python,rust noremap <buffer> gd :YcmCompleter GoTo<CR>
    au FileType c,cpp,cs,javascript*,typescript*,python,rust noremap <buffer> ge :YcmCompleter GetDoc<CR>
    au FileType c,cpp,cs,javascript*,typescript*,python,rust noremap <buffer> gh :YcmShowDetailedDiagnostic<CR>
    au FileType c,cpp,cs,javascript*,typescript*,python,rust noremap <buffer> gr :YcmCompleter GoToReferences<CR>
    au FileType c,cpp,cs,javascript*,typescript*,python,rust noremap <buffer> gt :YcmCompleter GetType<CR>
    au FileType c,cpp,cs,javascript*,typescript*,python,rust noremap <buffer> <leader>d :YcmDiags<CR>
    au FileType c,cpp,cs,javascript*,typescript*,python,rust noremap <buffer> <leader>r :YcmCompleter RefactorRename<space>
    au FileType c,cpp,cs,javascript*,typescript*,python,rust noremap <buffer> <leader>fi :YcmCompleter FixIt<CR>

    " Javascript
    " au FileType javascript*,typescript* call SetNeomakeExe('javascript_eslint', 'npx eslint')
    au FileType javascript*,typescript* noremap <buffer> <leader>D
      \ :execute "!open 'https://www.npmjs.com/package/".substitute(expand('<cWORD>'), '[''" ]', '', 'g')."'"<CR><CR>
    au FileType javascript* noremap <buffer> <leader>c :TestFile<CR>
    au FileType typescript* noremap <buffer> <leader>c :Neomake! tsc<CR>
    au FileType javascript*,typescript* noremap <buffer> <silent> <leader><leader>/ :JsDoc<CR>
    au FileType javascript*,typescript* noremap <buffer> <silent> <leader>fa :call JsArrowToFunction()<CR>
    au FileType javascript*,typescript* setlocal path+=app,src
    au FileType javascript*,typescript* setlocal makeprg=eslint\ %
    au FileType javascript*,typescript*,graphql,css,scss noremap <buffer> <leader>x :Neomake<CR>
    au FileType javascript*,typescript*,graphql noremap <buffer> <leader><leader>x :Neomake! eslint<CR>
    " Allow vim-test to detect mocha failures through neomake
    au FileType typescript* let b:current_compiler='tsc'
    au FileType typescript* setlocal errorformat=\ %#at\ %.%#\ (%f:%l:%c)
    au FileType json noremap <buffer> <silent> <leader>d :call jsonpath#echo()<CR>
    au FileType json noremap <buffer> <silent> <leader>g :call jsonpath#goto()<CR>
    au FileType json setlocal foldmethod=syntax foldlevel=99

    " CoffeeScript / Jade / LiveScript
    au FileType jade,coffee IFold
    au FileType coffee noremap <buffer> <leader>x :CoffeeCompile<CR>
    au FileType ls noremap <buffer> <leader>x :LiveScriptCompile<CR>
    au FileType ls setlocal indentkeys=o,O,},],0),!^F

    " LaTeX
    au FileType *tex setlocal errorformat=%f:%l:\ %m makeprg=pdflatex\ -file-line-error\ %
    if has("win32")
      au FileType *tex noremap <buffer> <leader>o :make<CR>:silent ! start "1" "%:r.pdf"<CR>
    else
      au FileType *tex noremap <buffer> <leader>o :make<CR>:silent !evince %:r.pdf &<CR>
    endif

    " Ruby
    au FileType ruby,haml setlocal formatoptions=ql
    au FileType ruby setlocal makeprg=ruby\ -c\ % errorformat=
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
    au FileType yaml,haml IFold

    au FileType python setlocal ts=4 sts=4 sw=4
    au FileType python noremap <buffer> <leader>o :!python %<CR>
    au FileType python setlocal makeprg=pylint\ %
    au FileType python setlocal efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

    au FileType html setlocal sts=2 ts=2 sw=2 expandtab autoindent

    au FileType css setlocal sts=2 ts=2 sw=2 noexpandtab

    au FileType scss setlocal iskeyword+=-
    au FileType scss setlocal makeprg=stylelint\ -f\ unix\ %

    " XML
    au FileType xml IFold

    " PHP
    "au BufRead,BufNewFile *.php,*.inc set ft=php.html
    au FileType php setlocal sts=2 ts=2 sw=2 expandtab autoindent
    au FileType php inoremap <buffer> <c-a>- <?php  ?><left><left><left>
    au FileType php inoremap <buffer> <c-a>= <?=  ?><left><left><left>
    au FileType php setlocal iskeyword-=$

    " Markdown
    if has("unix")
      au FileType markdown setlocal dictionary+=/usr/share/dict/words
    endif
    au FileType markdown setlocal infercase ai formatoptions=tcroqln
    au FileType markdown setlocal com=s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,b:-
    au FileType markdown noremap <buffer> <leader>. yypVr=<Esc>
    au FileType markdown noremap <buffer> <leader>- yypVr-<Esc>
    au FileType markdown vmap <buffer> <silent> <leader>c S`gv
    au FileType markdown vmap <buffer> <silent> <c-k> S]%a()<left>
    au FileType markdown vmap <buffer> <silent> <c-b> S*gv

    " C++
    "au FileType cpp setlocal foldmarker={,}
    if has("win32")
      au FileType c,cpp,h,hpp setlocal makeprg=mingw32-make
    else
      au FileType c,cpp,h,hpp setlocal makeprg=make
    endif
    au FileType cpp,hpp setlocal commentstring=//\ %s

    " Lua
    "au FileType lua setlocal tabstop=2 shiftwidth=2

    " Java
    au FileType java setlocal makeprg=ant\ -e\ -find
    let java_highlight_functions="style"

    " Go
    au FileType go setlocal makeprg=go\ build\ %
    au FileType go noremap <buffer> <leader>d :GoInfo<CR>
    au FileType go noremap <buffer> <leader>x :GoErrCheck<CR>

    " Help files
    au FileType help nmap <buffer> <CR> <C-]>

    " XQuery
    au FileType xquery setlocal makeprg=xqilla\ %

    " Matlab
    au FileType matlab setlocal makeprg=octave\ %

    " Snippets
    au FileType snippet setlocal noexpandtab foldexpr=IndentationFoldExpr(v:lnum) foldmethod=expr

    if has('mac')
      au FileType html,jade,coffee,javascript*,typescript*,scss,css,php
        \ setlocal keywordprg=:Dash
    end

    " {{{ JavaScript (EcmaScript 6+) tagbar configuration
    let g:tagbar_type_javascript = {
        \ 'ctagstype' : 'javascript',
        \ 'kinds'     : [
            \ 'c:classes',
            \ 'm:methods',
            \ 'f:functions',
            \ 'v:variables',
            \ 'f:fields',
        \ ]
    \ }
    " }}}

    " Python
    let g:pyindent_open_paren = 'shiftwidth()'
    let g:pyindent_continue = 'shiftwidth()'

  augroup END

" }}}
" {{{ Optionally load local rc file

  let s:local_rc_file = expand($HOME . '/.vimrc.local')
  if filereadable(s:local_rc_file)
    exec ':so ' . s:local_rc_file
  endif

" }}}
