function! s:to_lower_snake_case(str) abort
    if empty(a:str) == 1
        return ''
    endif

    if stridx(a:str, '_') == -1
        " UpperCamelCase or lowerCamelCase
        return tolower(a:str[0]) . substitute(a:str[1:-1], '\(\u\)', '\="_" . tolower(submatch(1))', 'g')
    else
        " lower_snake_case or UPPER_SNAKE_CASE
        return tolower(a:str)
    endif
endfunction

function! s:to_upper_snake_case(str) abort
    return toupper(s:to_lower_snake_case(a:str))
endfunction

function! s:to_lower_camel_case(str) abort
    if empty(a:str) == 1
        return ''
    endif

    if stridx(a:str, '_') == -1
        " UpperCamelCase or lowerCamelCase
        return tolower(a:str[0]) . a:str[1 : -1]
    else
        " lower_snake_case or UPPER_SNAKE_CASE
        return substitute(tolower(a:str), '_\(.\)', '\=toupper(submatch(1))', 'g')
    endif
endfunction

function! s:to_upper_camel_case(str) abort
    if empty(a:str) == 1
        return ''
    endif

    let l:str = s:to_lower_camel_case(a:str)
    return toupper(l:str[0]) . l:str[1 : -1]
endfunction

function! operator#convert_case#test() abort
    call assert_equal(s:to_lower_snake_case('lower_snake_case'), 'lower_snake_case')
    call assert_equal(s:to_lower_snake_case('UPPER_SNAKE_CASE'), 'upper_snake_case')
    call assert_equal(s:to_lower_snake_case('UpperCamelCase'),   'upper_camel_case')
    call assert_equal(s:to_lower_snake_case('lowerCamelCase'),   'lower_camel_case')
    call assert_equal(s:to_lower_snake_case(''), '')
    call assert_equal(s:to_lower_snake_case('Up'), 'up')

    call assert_equal(s:to_upper_snake_case('lower_snake_case'), 'LOWER_SNAKE_CASE')
    call assert_equal(s:to_upper_snake_case('UPPER_SNAKE_CASE'), 'UPPER_SNAKE_CASE')
    call assert_equal(s:to_upper_snake_case('UpperCamelCase'),   'UPPER_CAMEL_CASE')
    call assert_equal(s:to_upper_snake_case('lowerCamelCase'),   'LOWER_CAMEL_CASE')
    call assert_equal(s:to_upper_snake_case(''), '')
    call assert_equal(s:to_upper_snake_case('Up'), 'UP')

    call assert_equal(s:to_lower_camel_case('lower_snake_case'), 'lowerSnakeCase')
    call assert_equal(s:to_lower_camel_case('UPPER_SNAKE_CASE'), 'upperSnakeCase')
    call assert_equal(s:to_lower_camel_case('UpperCamelCase'),   'upperCamelCase')
    call assert_equal(s:to_lower_camel_case('lowerCamelCase'),   'lowerCamelCase')
    call assert_equal(s:to_lower_camel_case(''), '')
    call assert_equal(s:to_lower_camel_case('Up'), 'up')

    call assert_equal(s:to_upper_camel_case('lower_snake_case'), 'LowerSnakeCase')
    call assert_equal(s:to_upper_camel_case('UPPER_SNAKE_CASE'), 'UpperSnakeCase')
    call assert_equal(s:to_upper_camel_case('UpperCamelCase'),   'UpperCamelCase')
    call assert_equal(s:to_upper_camel_case('lowerCamelCase'),   'LowerCamelCase')
    call assert_equal(s:to_upper_camel_case(''), '')
    call assert_equal(s:to_upper_camel_case('Up'), 'Up')

    if len(v:errors)
        echoerr string(v:errors)
    else
        echomsg 'none'
    endif
endfunction


let s:function_mapper = {
            \ 'lowerCamelCase': function('s:to_lower_camel_case'),
            \ 'UpperCamelCase': function('s:to_upper_camel_case'),
            \ 'lower_snake_case': function('s:to_lower_snake_case'),
            \ 'UPPER_SNAKE_CASE': function('s:to_upper_snake_case'),
            \ }


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

    execute 'normal! a' . s:function_mapper[g:operator#convert_case#target_case](l:target_text)
endfunction
