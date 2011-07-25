" Browse just with <CR>/<BS>
" We allow remapping of <C-]> as ftplugin/man.vim remaps it
nmap <buffer><CR> <C-]>
nnoremap <buffer><BS> <C-T>
if &filetype == 'help'
  " Lookup |label| using <Tab>/<S-Tab>
  nnoremap <buffer> <Tab> /<Bar>\zs\k*\ze<Bar><CR>
  nnoremap <buffer> <S-Tab> ?<Bar>\zs\k*\ze<Bar><CR>
endif
