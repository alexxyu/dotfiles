" Set indent behavior
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab
set autoindent

set backspace=indent,eol,start
set nostartofline

" Set editor display
set ruler
set number
highlight LineNr ctermfg=grey
set cursorline
set showmode
syntax on

" Set search behavior
set hlsearch
set ignorecase
set incsearch

" Set other behavior
set mouse=a
set ve+=onemore
set clipboard=unnamed

" Strip trailing whitespace (,ss)
function! StripWhitespace()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>
