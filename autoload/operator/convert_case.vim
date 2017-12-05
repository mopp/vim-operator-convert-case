function! operator#convert_case#do(motion_wiseness) abort
    if a:motion_wiseness !=# 'char'
        echoerr 'This operator supports only characterwise.'
        return
    endif

    let l:store = @r

    let l:v = operator#user#visual_command_from_wise_name(a:motion_wiseness)
    execute 'normal!' '`[' . l:v . '`]"rc'
    let l:target_text = @r

    let @r = l:store

    execute 'normal! a' . convert_case#convert_to(g:operator#convert_case#target_case, l:target_text)
endfunction
