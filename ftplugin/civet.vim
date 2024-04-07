" Language:    Civet
" Maintainer:  Igor Kaplounenko
" URL:         https://github.com/IcarusMJ12/vim-civet
" License:     WTFPL
"
if exists("b:did_ftplugin")
  finish
endif

let b:did_ftplugin = 1

setlocal formatoptions-=t formatoptions+=croql
setlocal comments=://
setlocal commentstring=//\ %s
setlocal omnifunc=javascriptcomplete#CompleteJS
"
" Enable CivetMake if it won't overwrite any settings.
if !len(&l:makeprg)
  compiler civet
endif

" Check here too in case the compiler above isn't loaded.
if !exists('civet_compiler')
  let civet_compiler = 'civet'
endif
