"=============================================================================
" File: plugin/operator-convert-case.vim
" Author: mopp
" Created: 2017-12-04
"=============================================================================

scriptencoding utf-8

if exists('s:loaded')
    finish
endif
let s:loaded = 1

let s:save_cpo = &cpoptions
set cpoptions&vim


function! s:replace_word(case) abort
    let l:save_cursor = getcurpos()
    let l:store = @"

    execute 'normal! diw'
    execute 'normal! i' . convert_case#convert_to(a:case, @")

    let @" = l:store
    call setpos('.', l:save_cursor)
endfunction


let s:last_used_case = ''
function! s:map_convert() abort
    call inputsave()

    let s:last_used_case = input('target case: ', '', 'customlist,convert_case#case_list')

    if s:last_used_case ==# ''
        return
    endif

    call s:replace_word(s:last_used_case)

    if exists('*repeat')
        call repeat#set("\<Plug>(operator-convert-case-dummy)")
    endif

    call inputrestore()
endfunction


function! s:map_dummy() abort
    call s:replace_word(s:last_used_case)

    if exists('*repeat')
        call repeat#set("\<Plug>(operator-convert-case-dummy)")
    endif
endfunction


command! -nargs=0 ConvertTest call convert_case#test()

command! -nargs=0 LoopCase execute "normal \<Plug>(operator-convert-case-loop)iw"
command! -nargs=0 ToggleUpperLower execute "normal \<Plug>(operator-convert-case-toggle-upper-lower)iw"
command! -nargs=1 -complete=customlist,convert_case#case_list ConvertCase call <SID>replace_word(<f-args>)

nnoremap <script> <Plug>(operator-convert-case-convert) :<C-U>call <SID>map_convert()<CR>
nnoremap <script> <Plug>(operator-convert-case-dummy) :<C-U>call <SID>map_dummy()<CR>


let &cpoptions = s:save_cpo
unlet s:save_cpo
