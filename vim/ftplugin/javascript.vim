if (exists("b:did_ftplugin"))
  finish
endif
let b:did_ftplugin = 1

let &makeprg="node %"

" Exclude referenced files from <C-n> completion
setlocal complete-=i

" Error: bar
"     at Object.foo [as _onTimeout] (/Users/Me/src/nodeproject/index.js:2:9)
let &errorformat  = '%AError: %m' . ','
let &errorformat .= '%AEvalError: %m' . ','
let &errorformat .= '%ARangeError: %m' . ','
let &errorformat .= '%AReferenceError: %m' . ','
let &errorformat .= '%ASyntaxError: %m' . ','
let &errorformat .= '%ATypeError: %m' . ','
let &errorformat .= '%Z%*[\ ]at\ %f:%l:%c' . ','
let &errorformat .= '%Z%*[\ ]%m (%f:%l:%c)' . ','

"     at Object.foo [as _onTimeout] (/Users/Me/src/nodeproject/index.js:2:9)
let &errorformat .= '%*[\ ]%m (%f:%l:%c)' . ','

"     at node.js:903:3
let &errorformat .= '%*[\ ]at\ %f:%l:%c' . ','

" /Users/Me/src/nodeproject/index.js:2
"   throw new Error('bar');
"         ^
let &errorformat .= '%Z%p^,%A%f:%l,%C%m' . ','

" Ignore everything else
" let &errorformat .= '%-G%.%#'

let &errorformat .= '%-G\\s%#'
