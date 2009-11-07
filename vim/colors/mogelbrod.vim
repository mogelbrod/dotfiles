" mogelbrod vim color scheme
" author: Victor Hallberg [ vigge19@gmail.com ]
" date: 2009-06-28
" test with :source $VIMRUNTIME/syntax/colortest.vim

let colors_name = "mogelbrod"

set background=dark
hi clear

if version > 580
    hi clear
    if exists("syntax_on")
		syntax reset
    endif
endif


" VIM colors
"==========================================================

" Default Colors
hi Normal         ctermfg=none ctermbg=none cterm=none
hi NonText        ctermfg=Black ctermbg=none cterm=bold

" Cursor
hi Cursor         ctermfg=Black ctermbg=White cterm=reverse
"hi lCursor        ctermfg=none ctermbg=none cterm=none
"hi CursorLine     ctermfg=none ctermbg=none cterm=none
"hi CursorColumn   ctermfg=none ctermbg=none cterm=none

" Search
hi Search         ctermfg=Black ctermbg=Brown cterm=none
hi IncSearch      ctermfg=Black ctermbg=Brown cterm=none
hi MatchParen     ctermfg=White ctermbg=Cyan cterm=bold

" Window Elements
hi LineNr         ctermfg=Grey ctermbg=none cterm=none
hi StatusLine     ctermfg=Black ctermbg=Grey cterm=none
hi StatusLineNC   ctermfg=Black ctermbg=Grey cterm=bold
hi VertSplit      ctermfg=Black ctermbg=Grey cterm=none
hi Folded         ctermfg=Cyan ctermbg=Black cterm=none
hi FoldColumn     ctermfg=Cyan ctermbg=Black cterm=none
hi Visual         ctermfg=Black ctermbg=Grey cterm=none
hi VisualNOS      ctermfg=White ctermbg=none cterm=none

" Popup menu
hi Pmenu          ctermfg=White ctermbg=Black cterm=none
hi PmenuSel       ctermfg=Cyan ctermbg=Black cterm=none
hi PmenuSbar      ctermfg=Black ctermbg=Black cterm=bold
hi PmenuThumb     ctermfg=Black ctermbg=Black cterm=bold

" Specials
hi Title          ctermfg=Cyan ctermbg=none cterm=none


" Basic syntax
"==========================================================

" Comments
hi Comment        ctermfg=Black ctermbg=none cterm=bold
hi SpecialComment ctermfg=Black ctermbg=none cterm=bold

" Constants
hi Constant       ctermfg=Green ctermbg=none cterm=bold
hi Boolean        ctermfg=Green ctermbg=none cterm=bold
" Text
hi Character      ctermfg=Magenta ctermbg=none cterm=bold
hi String         ctermfg=Magenta ctermbg=none cterm=bold
" Numbers
hi Number         ctermfg=Magenta ctermbg=none cterm=none
hi Float          ctermfg=Magenta ctermbg=none cterm=none

" Identifiers
hi Identifier     ctermfg=Red ctermbg=none cterm=none
hi Function       ctermfg=Red ctermbg=none cterm=none

" Statements
hi Statement      ctermfg=Brown ctermbg=none cterm=none
"hi Conditional    ctermfg=Brown ctermbg=none cterm=none
"hi Repeat         ctermfg=Brown ctermbg=none cterm=none
"hi Label          ctermfg=Brown ctermbg=none cterm=none
"hi Operator       ctermfg=Brown ctermbg=none cterm=none
"hi Keyword        ctermfg=Brown ctermbg=none cterm=none
"hi Exception      ctermfg=Brown ctermbg=none cterm=none

" Preprocessors
hi PreProc        ctermfg=Cyan ctermbg=none cterm=none
"hi Include        ctermfg=Cyan ctermbg=none cterm=none
"hi Define         ctermfg=Cyan ctermbg=none cterm=none
"hi Macro          ctermfg=Cyan ctermbg=none cterm=none
"hi PreCondit      ctermfg=Cyan ctermbg=none cterm=none

" Types
hi Type           ctermfg=Green ctermbg=none cterm=none
"hi StorageClass   ctermfg=Green ctermbg=none cterm=none
"hi Structure      ctermfg=Green ctermbg=none cterm=none
"hi Typedef        ctermfg=Green ctermbg=none cterm=none

" Special symbols
hi Special        ctermfg=Blue ctermbg=none cterm=bold
hi SpecialChar    ctermfg=Green ctermbg=none cterm=none
hi Tag            ctermfg=Cyan ctermbg=none cterm=bold
hi Delimeter      ctermfg=White ctermbg=none cterm=none
hi Debug          ctermfg=Red ctermbg=none cterm=bold

" Other stuff
hi Error          ctermfg=White ctermbg=Red cterm=none
hi Ignored        ctermfg=White ctermbg=none cterm=bold
hi Todo           ctermfg=White ctermbg=none cterm=bold
hi Underlined     ctermfg=White ctermbg=none cterm=underline


" File type specific
"==========================================================

" HTML
hi link htmlH1 Normal
hi link htmlLink Normal
hi link htmlItalic Normal
hi link htmlBold Normal
"hi link htmlStatement PreProc
"hi link htmlArg Tag
