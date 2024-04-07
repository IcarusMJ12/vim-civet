" Language:    Civet
" Maintainer:  Igor Kaplounenko
" URL:         https://github.com/IcarusMJ12/vim-civet
" License:     WTFPL
"
if exists('b:current_syntax') && b:current_syntax == 'civet'
  finish
endif

let b:current_syntax = "civet"

" Highlight long strings.
syntax sync minlines=100

setlocal iskeyword=48-57,A-Z,$,a-z,_

syntax match civetIdentifier /[$A-Za-z_]\k*/
highlight default link civetIdentifier Identifier

" These are 'matches' rather than 'keywords' because vim's highlighting priority
" for keywords (the highest) causes them to be wrongly highlighted when used as
" dot-properties.
syntax match civetStatement /\<\%(return\|break\|continue\|throw\)\>/
highlight default link civetStatement Statement

syntax match civetRepeat /\<\%(for\%( own\| ever\)\?\|while\|until\)\>/
highlight default link civetRepeat Repeat

syntax match civetConditional /\<\%(if\|else\|unless\|switch\|case\|when\|default\|match\)\>/
highlight default link civetConditional Conditional

syntax match civetException /\<\%(try\|catch\|finally\)\>/
highlight default link civetException Exception

syntax match civetKeyword /\<\%(new\|in\%(stanceof\)\?\|typeof\|delete\|and\|o[fr]\|not\|xor\|is\|isnt\|imp\%(ort\%( all\)\?\|lements\)\|extends\|loop\|from\|to\|til\|by\|do\|then\|function\|class\|let\|with\|export\|const\|var\|eval\|super\|fallthrough\|debugger\|where\|yield\)\>/
highlight default link civetKeyword Keyword

syntax match civetBoolean /\<\%(true\|false\|yes\|no\|on\|off\|null\|void\)\>/
highlight default link civetBoolean Boolean

" Matches context variables.
syntax match civetContext /\<\%(this\|arguments\|it\|that\|constructor\|prototype\|superclass\)\>/
highlight default link civetContext Type

" Keywords reserved by the language
syntax cluster civetReserved contains=civetStatement,civetRepeat,civetConditional,
\                                  civetException,civetOperator,civetKeyword,civetBoolean

" Matches ECMAScript 5 built-in globals.
syntax match civetGlobal /\<\%(Array\|Boolean\|Date\|Function\|JSON\|Math\|Number\|Object\|RegExp\|String\|\%(Syntax\|Type\|URI\)\?Error\|is\%(NaN\|Finite\)\|parse\%(Int\|Float\)\|\%(en\|de\)codeURI\%(Component\)\?\)\>/
highlight default link civetGlobal Structure

syntax region civetString start=/"/ skip=/\\\\\|\\"/ end=/"/ contains=@civetInterpString
syntax region civetString start=/'/ skip=/\\\\\|\\'/ end=/'/ contains=@civetSimpleString
highlight default link civetString String

" Matches decimal/floating-point numbers like 10.42e-8.
syntax match civetFloat
\ /\%(\<-\?\|-\)\zs\d[0-9_]*\%(\.\d[0-9_]*\)\?\%(e[+-]\?\d[0-9_]*\)\?\%([a-zA-Z$][$a-zA-Z0-9_]*\)\?/
\ contains=civetNumberComment
highlight default link civetFloat Float
syntax match civetNumberComment /\d\+\zs\%(e[+-]\?\d\)\@![a-zA-Z$][$a-zA-Z0-9_]*/ contained
highlight default link civetNumberComment Comment
" Matches hex numbers like 0xfff, 0x000.
syntax match civetNumber /\%(\<-\?\|-\)\zs0x\x\+/
" Matches N radix numbers like 2@1010.
syntax match civetNumber
\ /\%(\<-\?\|-\)\zs\%(\d*\)\~[0-9A-Za-z][0-9A-Za-z_]*/
highlight default link civetNumber Number

" Displays an error for reserved words.
syntax match civetReservedError /\<\%(enum\|interface\|package\|private\|protected\|public\|static\)\>/
highlight default link civetReservedError Error

syntax keyword civetTodo TODO FIXME XXX contained
highlight default link civetTodo Todo

syntax match civetComment /#!.*$/                  contains=@Spell
syntax match civetComment /\/\/.*$/                contains=@Spell,civetTodo
syntax region civetComment start=/\/\*/ end=/\*\// contains=@Spell,civetTodo
highlight default link civetComment Comment

syntax region civetInfixFunc start=/`/ end=/`/
highlight default link civetInfixFunc Identifier

syntax region civetInterpolation matchgroup=civetInterpDelim
\                                 start=/\#{/ end=/}/
\                                 contained contains=TOP
highlight default link civetInterpDelim Delimiter

" Matches escape sequences like \000, \x00, \u0000, \n.
syntax match civetEscape /\\\d\d\d\|\\x\x\{2\}\|\\u\x\{4\}\|\\./ contained
highlight default link civetEscape SpecialChar

syntax match civetVarInterpolation /#[$A-Za-z_]\k*\(-[a-zA-Z]\+\)*/ contained
highlight default link civetVarInterpolation Identifier

" What is in a non-interpolated string
syntax cluster civetSimpleString contains=@Spell,civetEscape
" What is in an interpolated string
syntax cluster civetInterpString contains=@civetSimpleString,
\                                      civetInterpolation,civetVarInterpolation

syntax region civetHeredoc start=/"""/ end=/"""/ contains=@civetInterpString fold
syntax region civetHeredoc start=/'''/ end=/'''/ contains=@civetSimpleString fold
highlight default link civetHeredoc String

syntax match civetWord /\\\S[^ \t\r,;)}\]]*/
highlight default link civetWord String

syntax region civetWords start=/<\[/ end=/\]>/ contains=fold
highlight default link civetWords String

" Reserved words can be used as property names.
syntax match civetProp /[$A-Za-z_]\k*[ \t]*:[:=]\@!/
highlight default link civetProp Label

syntax match civetKey
\ /\%(\.\@<!\.\%(=\?\s*\|\.\)\|[]})@?]\|::\)\zs\k\+/
\ transparent
\ contains=ALLBUT,civetNumberComment,civetIdentifier,civetContext,civetGlobal,civetReservedError,@civetReserved

" Displays an error for trailing whitespace.
syntax match civetSpaceError /\s\+$/ display
highlight default link civetSpaceError Error

if !exists('b:current_syntax')
  let b:current_syntax = 'civet'
endif
