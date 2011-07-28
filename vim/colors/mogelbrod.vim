" mogelbrod2 vim color scheme
" author: Victor Hallberg [ vigge19@gmail.com ]
" date: 2010-04-04
" test with :source $VIMRUNTIME/syntax/colortest.vim

let g:colors_name = "mogelbrod"

set background=dark
hi clear

if version > 580
	hi clear
	if exists("syntax_on")
		syntax reset
	endif
endif

" {{{ VIM Colors ===============================================================

" Default Colors
hi Normal				ctermfg=none	ctermbg=none	cterm=none		guifg=#d0d0d0	guibg=#1e1e1e	gui=none
hi NonText			ctermfg=Black	ctermbg=none	cterm=bold		guifg=#828282	guibg=#1e1e1e	gui=none

" Cursor
hi Cursor				ctermfg=Black	ctermbg=White	cterm=reverse	guifg=#ffffff	guibg=#5082a0	gui=none
hi lCursor			ctermfg=none	ctermbg=none	cterm=none		guifg=#ffffff	guibg=#5082a0	gui=none
hi CursorLine		ctermfg=none	ctermbg=none	cterm=none		guibg=#1b1b1b	gui=none
hi CursorColumn	ctermfg=none	ctermbg=none	cterm=none		guibg=#1b1b1b	gui=none

" Search
hi Search				ctermfg=Black	ctermbg=Brown	cterm=none		guifg=#141414	guibg=#f0b43c	gui=none
hi IncSearch		ctermfg=Black	ctermbg=Brown	cterm=bold		guifg=#141414	guibg=#ffcd64	gui=none
hi MatchParen		ctermfg=White	ctermbg=Black cterm=bold		guifg=#ffffff	guibg=#334455 gui=none

" Window Elements
hi LineNr				ctermfg=Grey	ctermbg=none	cterm=none		guifg=#626262	guibg=#141414	gui=none
hi StatusLine		ctermfg=Black	ctermbg=Grey	cterm=none		guifg=#ffffff	guibg=#0a0a0a	gui=none
hi StatusLineNC	ctermfg=Black	ctermbg=Grey	cterm=bold		guifg=#a6a6a6	guibg=#0a0a0a	gui=none
hi VertSplit		ctermfg=Black	ctermbg=Grey	cterm=none		guifg=#ffffff	guibg=#0a0a0a	gui=none
hi Folded				ctermfg=Cyan	ctermbg=Black	cterm=none		guifg=#3cb9e6	guibg=#151515	gui=none
hi FoldColumn		ctermfg=Cyan	ctermbg=Black	cterm=none		guifg=#3cb9e6	guibg=#1e1e1e	gui=none
hi Visual				ctermfg=Black	ctermbg=Grey	cterm=none		guifg=#f0f0f0	guibg=#464646	gui=none
hi VisualNOS		ctermfg=White	ctermbg=none	cterm=none		guifg=#f0f0f0	gui=none

" Popup menu
hi Pmenu				ctermfg=White	ctermbg=Black	cterm=none		guifg=#cacaca	guibg=#0b0b0b	gui=none
hi PmenuSel			ctermfg=Cyan	ctermbg=Black	cterm=none		guifg=#3cb9e6	guibg=#0b0b0b	gui=none
hi PmenuSbar		ctermfg=Black	ctermbg=Black	cterm=bold		guifg=#464646	guibg=#0b0b0b	gui=none
hi PmenuThumb		ctermfg=Black	ctermbg=Black	cterm=bold		guifg=#464646	guibg=#0b0b0b	gui=none

" Specials
hi Title				ctermfg=Cyan	ctermbg=none	cterm=none		guifg=#78c8e6	gui=none

" GUI restyles
hi WarningMsg		guifg=#f64a4a	gui=none
hi ErrorMsg			guifg=#ffffff	guibg=#f03a3a	gui=none
hi DiffText			guifg=#ffffff	guibg=#f03a3a	gui=none
hi MoreMsg			guifg=#78dc1e	gui=none
hi Question			guifg=#78dc1e	gui=none
hi TabLineSel		gui=none
hi ModeSel			gui=none
hi ModeMsg			gui=none

" }}}
" {{{ VimDiff
hi DiffAdd 			ctermfg=Black ctermbg=Green 	cterm=none
hi DiffDelete 	ctermfg=Black ctermbg=Red 		cterm=none
hi DiffChange 	ctermfg=Black ctermbg=Yellow  cterm=none
hi DiffText 		ctermfg=Black ctermbg=Yellow 	cterm=none
" }}}
" {{{ Basic syntax =============================================================

" Comments
hi Comment			ctermfg=Black	ctermbg=none	cterm=bold		guifg=#646464	gui=none
hi SpecialComment	ctermfg=Black	ctermbg=none	cterm=bold		guifg=#646464	gui=none

" Constants
hi Constant			ctermfg=Green	ctermbg=none	cterm=bold		guifg=#a0ffa0	gui=none
hi Boolean			ctermfg=Green	ctermbg=none	cterm=bold		guifg=#a0ffa0	gui=none
" Text
hi Character		ctermfg=Magenta	ctermbg=none	cterm=bold		guifg=#e664e6	gui=none
hi String			ctermfg=Magenta	ctermbg=none	cterm=bold		guifg=#e664e6	gui=none
" Numbers
hi Number			ctermfg=Magenta	ctermbg=none	cterm=none		guifg=#f050f0	gui=none
hi Float			ctermfg=Magenta	ctermbg=none	cterm=none		guifg=#f050f0	gui=none

" Identifiers
hi Identifier		ctermfg=Red		ctermbg=none	cterm=none		guifg=#f65a5a	gui=none
hi Function			ctermfg=Red		ctermbg=none	cterm=none		guifg=#f65a5a	gui=none

" Statements
hi Statement		ctermfg=Brown	ctermbg=none	cterm=none		guifg=#f0b43c	gui=none
"hi Conditional
"hi Repeat
"hi Label
"hi Operator
"hi Keyword
"hi Exception

" Preprocessors
hi PreProc			ctermfg=Cyan	ctermbg=none	cterm=none		guifg=#3cb9e6	gui=none
"hi Include
"hi Define
"hi Macro
"hi PreCondit

" Types
hi Type				ctermfg=Green	ctermbg=none	cterm=none		guifg=#78dc1e	gui=none
"hi StorageClass
"hi Structure
"hi Typedef

" Special symbols
hi Special			ctermfg=Blue	ctermbg=none	cterm=bold		guifg=#7373e6	gui=none
hi SpecialChar		ctermfg=Green	ctermbg=none	cterm=none		guifg=#78dc1e	gui=none
hi Tag				ctermfg=Cyan	ctermbg=none	cterm=bold		guifg=#3cb9e6	gui=none
hi Delimeter		ctermfg=White	ctermbg=none	cterm=none		guifg=#ffffff	gui=none
hi Debug			ctermfg=Red		ctermbg=none	cterm=bold		guifg=#f35d5d	gui=none

" Other stuff
hi Error			ctermfg=White	ctermbg=Red		cterm=none		guifg=#ffcccc	guibg=#aa3333	gui=none
hi Ignored			ctermfg=White	ctermbg=none	cterm=bold		guifg=#ffffff	gui=none
hi Todo				ctermfg=White	ctermbg=none	cterm=bold		guifg=yellow	guibg=bg		gui=none
hi Underlined		ctermfg=White	ctermbg=none	cterm=underline	guifg=#ffffff	gui=none

" }}}
" {{{ File type specific =======================================================

" HTML
hi link htmlH1 Normal
hi link htmlLink Normal
hi link htmlItalic Normal
hi link htmlBold Normal
"hi link htmlStatement PreProc
"hi link htmlArg Tag

" }}}
