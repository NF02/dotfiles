" syntex: vim
" Disable function highlighting (affects both C and C++ files)
let g:cpp_no_function_highlight = 1

" Enable highlighting of C++11 attributes
let g:cpp_attributes_highlight = 1

" Highlight struct/class member variables (affects both C and C++ files)
let g:cpp_member_highlight = 1

" Put all standard C and C++ keywords under Vim's highlight group 'Statement'
" (affects both C and C++ files)
let g:cpp_simple_highlight = 1


autocmd FileType cpp inoremap ,cout cout<Space><<<Space>"<++>"<Space><<<Space>endl;<Esc>FbT>i
autocmd FileType cpp inoremap ,cin cin<Space><<<Space><++>;<Esc>FbT>i
autocmd FileType c,cpp inoremap ,for for(<++>;<Space><++>;<Space><++>)<Space>{<Enter><tab><++><Enter>}<Esc>FbT>i
autocmd FileType c,cpp inoremap ,if if(<++>)
autocmd FileType c,cpp inoremap ,ielse if(<++>)<Space>{<Enter><tab><++><Enter>}<Space>else<Space>{<Enter><tab><++><Enter>}<Esc>FbT>i
autocmd FileType c,cpp inoremap ,def #define<Space><++>
autocmd FileType cpp inoremap ,class class<Space><nameClass><Space>{<Enter>Public:<Enter><tab><++><Enter>};

