"""""""""""""""""""""""
" Set indent behavior "
"""""""""""""""""""""""
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab
set autoindent
set backspace=indent,eol,start
set nostartofline

""""""""""""""""""""""
" Set editor display "
""""""""""""""""""""""
set ruler
set number
set cursorline
set showmode
set background=light
syntax on
highlight LineNr ctermfg=grey

"""""""""""""""""""""""
" Set search behavior "
"""""""""""""""""""""""
set hlsearch
set ignorecase
set incsearch

""""""""""""""""""""""
" Set other behavior "
""""""""""""""""""""""
set mouse=a
set ve+=onemore
set clipboard=unnamed
set encoding=utf-8
set updatetime=300

"""""""""""""
" Shortcuts "
"""""""""""""
function! StripWhitespace()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>

:map <C-a> <Home>
:map <C-e> <End>

""""""""""""
" vim-plug "
""""""""""""
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'airblade/vim-gitgutter'

Plug 'tpope/vim-fugitive'

Plug 'NLKNguyen/papercolor-theme'

call plug#end()

""""""""""""
" coc.nvim "
""""""""""""

" install coc plugins
let g:coc_global_extensions = ['coc-pyright', 'coc-json', 'coc-go', 'coc-tsserver', 'coc-html', 'coc-css', 'coc-yaml']

inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

let g:gitgutter_set_sign_backgrounds = 1
highlight GitGutterAdd    guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermfg=1

"""""""""""""
" gitgutter "
"""""""""""""

" Workaround a problem with solarized and vim-gitgutter.
" https://github.com/airblade/vim-gitgutter/issues/696
highlight! link SignColumn LineNr
autocmd ColorScheme * highlight! link SignColumn LineNr

"""""""""
" theme "
"""""""""
colorscheme PaperColor

