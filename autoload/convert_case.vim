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


function! s:detect_word_case(word) abort
    if stridx(a:word, '_') != -1
        return (toupper(a:word) ==# a:word) ? 'UPPER_SNAKE_CASE' : 'lower_snake_case'
    else
        return (a:word[0] =~# '[a-z]') ? 'lowerCamelCase' : 'UpperCamelCase'
    endif
endfunction


function! s:replace_word(word) abort
    let l:save_cursor = getcurpos()

    execute 'normal! ciw' . a:word

    call setpos('.', l:save_cursor)
endfunction


function! convert_case#test() abort
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

    call assert_equal('lowerCamelCase', s:detect_word_case('someVariable'))
    call assert_equal('UpperCamelCase', s:detect_word_case('SomeVar'))
    call assert_equal('lower_snake_case', s:detect_word_case('this_is_var'))
    call assert_equal('UPPER_SNAKE_CASE', s:detect_word_case('THIS_IS_VAR'))

    if len(v:errors)
        echoerr string(v:errors)
    else
        echomsg 'none'
    endif
endfunction


function! convert_case#case_list(...) abort
    return ['lower_snake_case', 'UPPER_SNAKE_CASE', 'lowerCamelCase', 'UpperCamelCase']
endfunction


function! convert_case#convert_to(case, word) abort
    let l:function_map =  {
                \ 'lowerCamelCase': function('s:to_lower_camel_case'),
                \ 'UpperCamelCase': function('s:to_upper_camel_case'),
                \ 'lower_snake_case': function('s:to_lower_snake_case'),
                \ 'UPPER_SNAKE_CASE': function('s:to_upper_snake_case'),
                \ }

    return l:function_map[a:case](a:word)
endfunction


function! convert_case#replace_by(case, word) abort
    let l:converted = convert_case#convert_to(a:case, a:word)

    call s:replace_word(l:converted)
endfunction


function! convert_case#toggle_case(word, case1, case2) abort
    let l:case = s:detect_word_case(a:word)
    let l:converted = (a:case1 ==# l:case) ? convert_case#convert_to(a:case2, a:word) : convert_case#convert_to(a:case1, a:word)

    call s:replace_word(l:converted)
endfunction


let s:letter_mapper = {
            \ 'lowerCamelCase': function('s:to_upper_camel_case'),
            \ 'UpperCamelCase': function('s:to_lower_camel_case'),
            \ 'lower_snake_case': function('s:to_upper_snake_case'),
            \ 'UPPER_SNAKE_CASE': function('s:to_lower_snake_case'),
            \ }

function! convert_case#toggle_upper_lower(word) abort
    let l:case = s:detect_word_case(a:word)
    let l:converted = s:letter_mapper[l:case](a:word)

    call s:replace_word(l:converted)
endfunction


function! convert_case#loop(word) abort
    let l:case = s:detect_word_case(a:word)

    let l:all_cases = convert_case#case_list()
    let l:i = (index(l:all_cases, l:case) + 1) % len(l:all_cases)
    let l:next_case = l:all_cases[l:i]

    let l:converted = convert_case#convert_to(l:next_case, a:word)
    call s:replace_word(l:converted)
endfunction
