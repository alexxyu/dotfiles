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
syntax on
highlight LineNr ctermfg=grey

" neovim changes the terminal cursor; this respects the cursor on exit
augroup RestoreCursorShapeOnExit
    autocmd!
    autocmd VimLeave * set guicursor=a:ver1
augroup END

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
" Set leader to space
nnoremap <SPACE> <Nop>
let mapleader=" "

" Strip white
function! StripWhitespace()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>

" Emacs-style navigation
noremap <C-A> <Home>
noremap <C-E> <End>

" Auto-closing braces
inoremap {<cr> {<cr>}<c-o>O

" Quick escape
inoremap kj <Esc>
inoremap jk <Esc>

" Redo
nnoremap U <C-R>

" Clear search highlight on <CR>
nnoremap <CR> <Cmd>noh<CR><Bar><Cmd>echon<CR><CR>

" Plugin keybindings
nnoremap <leader>nt :NERDTreeToggle<CR>
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fl :Lines<CR>
nnoremap <leader>fr :Rg

""""""""""""
" vim-plug "
""""""""""""
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'catppuccin/nvim', { 'as': 'catppuccin' }

Plug 'dracula/vim', { 'as': 'dracula' }

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'preservim/nerdtree'

Plug 'junegunn/vim-peekaboo'

Plug 'airblade/vim-gitgutter'

Plug 'tpope/vim-fugitive'

Plug 'tpope/vim-surround'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'mg979/vim-visual-multi', {'branch': 'master'}

Plug 'Raimondi/delimitMate'

Plug 'lukas-reineke/indent-blankline.nvim'

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

"""""""
" FZF "
"""""""

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --hidden --glob "!.git/" --line-number --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

""""""""""""""""""""
" indent-blankline "
""""""""""""""""""""

lua require("ibl").setup()

"""""""""
" theme "
"""""""""

if !empty($TERM_BG)
    :let &background = $TERM_BG
    set termguicolors
    colorscheme dracula
else
    :let &background = 'light'
    colorscheme catppuccin-latte
endif
