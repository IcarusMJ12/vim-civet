" Language:    Civet
" Maintainer:  Igor Kaplounenko
" URL:         https://github.com/IcarusMJ12/vim-civet
" License:     WTFPL
"
if exists('current_compiler')
  finish
endif

let current_compiler = 'civet'
" Pattern to check if civet is the compiler
let s:pat = '^' . current_compiler

" Path to Civet compiler
if !exists('civet_compiler')
  let civet_compiler = 'civet'
endif

if !exists('civet_make_options')
  let civet_make_options = ''
endif

" Get a `makeprg` for the current filename. This is needed to support filenames
" with spaces and quotes, but also not break generic `make`.
function! s:GetMakePrg()
  return g:civet_compiler . ' -c ' . g:civet_make_options . ' $* '
  \                      . fnameescape(expand('%'))
endfunction

" Set `makeprg` and return 1 if civet is still the compiler, else return 0.
function! s:SetMakePrg()
  if &l:makeprg =~ s:pat
    let &l:makeprg = s:GetMakePrg()
  elseif &g:makeprg =~ s:pat
    let &g:makeprg = s:GetMakePrg()
  else
    return 0
  endif

  return 1
endfunction

" Set a dummy compiler so we can check whether to set locally or globally.
CompilerSet makeprg=civet
call s:SetMakePrg()

CompilerSet errorformat=%EFailed\ at:\ %f,
                       \%ECan't\ find:\ %f,
                       \%CSyntaxError:\ %m\ on\ line\ %l,
                       \%CError:\ Parse\ error\ on\ line\ %l:\ %m,
                       \%C,%C\ %.%#

" Compile the current file.
command! -bang -bar -nargs=* CM make<bang> <args>

" Set `makeprg` on rename since we embed the filename in the setting.
augroup CivetUpdateMakePrg
  autocmd!

  " Update `makeprg` if civet is still the compiler, else stop running this
  " function.
  function! s:UpdateMakePrg()
    if !s:SetMakePrg()
      autocmd! CivetUpdateMakePrg
    endif
  endfunction

  " Set autocmd locally if compiler was set locally.
  if &l:makeprg =~ s:pat
    autocmd BufFilePost,BufWritePost <buffer> call s:UpdateMakePrg()
  else
    autocmd BufFilePost,BufWritePost          call s:UpdateMakePrg()
  endif
augroup END
