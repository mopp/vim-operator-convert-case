if exists('g:loaded_operator_convert_case')
    finish
endif


call operator#user#define('convert-case-lower-camel', 'operator#convert_case#do', 'let g:operator#convert_case#target_case = "lowerCamelCase"')
call operator#user#define('convert-case-upper-camel', 'operator#convert_case#do', 'let g:operator#convert_case#target_case = "UpperCamelCase"')
call operator#user#define('convert-case-lower-snake', 'operator#convert_case#do', 'let g:operator#convert_case#target_case = "lower_snake_case"')
call operator#user#define('convert-case-upper-snake', 'operator#convert_case#do', 'let g:operator#convert_case#target_case = "UPPER_SNAKE_CASE"')


let g:loaded_operator_convert_case = 1
