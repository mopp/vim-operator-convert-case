function! s:get_target_text(motion_wiseness) abort
    if a:motion_wiseness !=# 'char'
        echoerr 'This operator supports only characterwise.'
        return
    endif

    let l:store = @r

    let l:v = operator#user#visual_command_from_wise_name(a:motion_wiseness)
    execute 'normal!' '`[' . l:v . '`]"rd'
    let l:target_text = @r

    let @r = l:store

    return l:target_text
endfunction


function! operator#convert_case#convert_to(motion_wiseness) abort
    let l:target_text = s:get_target_text(a:motion_wiseness)
    execute 'normal! i' . convert_case#convert_to(g:operator#convert_case#target_case, l:target_text)
endfunction


function! operator#convert_case#toggle_upper_lower(motion_wiseness) abort
    let l:target_text = s:get_target_text(a:motion_wiseness)
    execute 'normal! i' . convert_case#toggle_upper_lower(l:target_text)
endfunction


function! operator#convert_case#loop(motion_wiseness) abort
    let l:target_text = s:get_target_text(a:motion_wiseness)
    execute 'normal! i' . convert_case#loop(l:target_text)
endfunction
