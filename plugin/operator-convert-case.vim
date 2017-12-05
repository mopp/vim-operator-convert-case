"=============================================================================
" File: plugin/operator-convert-case.vim
" Author: mopp
" Created: 2017-12-04
"=============================================================================

scriptencoding utf-8

if exists('g:loaded_operator_convert_case')
    finish
endif
let g:loaded_operator_convert_case = 1

let s:save_cpo = &cpo
set cpo&vim


function! s:map_toggle_upper_lower() abort
    :ToggleUpperLower

    if exists('*repeat')
        call repeat#set("\<Plug>(operator-convert-toggle-upper-lower)")
    endif
endfunction


let s:last_used_case = ''
function! s:map_convert() abort
    call inputsave()

    let s:last_used_case = input('target case: ', '', 'customlist,convert_case#case_list')

    if s:last_used_case == ''
        return
    endif

    call convert_case#replace_by(s:last_used_case, expand('<cword>'))

    if exists('*repeat')
        call repeat#set("\<Plug>(operator-convert-dummy)")
    endif

    call inputrestore()
endfunction


function! s:map_dummy() abort
    call convert_case#replace_by(s:last_used_case, expand('<cword>'))

    if exists('*repeat')
        call repeat#set("\<Plug>(operator-convert-dummy)")
    endif
endfunction


command! -nargs=0 ConvertTest call convert_case#test()
command! -nargs=0 ToggleUpperLower call convert_case#toggle_upper_lower(expand('<cword>'))
command! -nargs=1 -complete=customlist,convert_case#case_list ConvertCase call convert_case#replace(expand('<cword>'), <f-args>)
command! -nargs=0 LoopCase call convert_case#loop(expand('<cword>'))

nnoremap <script> <Plug>(operator-convert-dummy) :<C-U>call <SID>map_dummy()<CR>

nnoremap <script> <Plug>(operator-convert-convert) :<C-U>call <SID>map_convert()<CR>
nnoremap <script> <Plug>(operator-convert-toggle-upper-lower) :<C-U>call <SID>map_toggle_upper_lower()<CR>


let &cpo = s:save_cpo
unlet s:save_cpo
