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
set clipboard^=unnamed,unnamedplus
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

" Quick escape
inoremap kj <Esc>
inoremap jk <Esc>

" Redo
nnoremap U <C-R>

" Clear search highlight on <CR>
nnoremap <CR> <Cmd>noh<CR><Bar><Cmd>echon<CR><CR>

" Buffer navigation
nnoremap <Tab> :bn<CR>
nnoremap <S-Tab> :bp<CR>
nnoremap <C-W> :bd<CR>

" Plugin keybindings
nnoremap <leader>nt :NERDTreeToggle<CR>
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fl :Lines<CR>
nnoremap <leader>cs :Rg<CR>

"""""""""""""""
" vim plugins "
"""""""""""""""

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'catppuccin/nvim', { 'as': 'catppuccin' }

Plug 'dracula/vim', { 'as': 'dracula' }

Plug 'preservim/nerdtree'

Plug 'junegunn/vim-peekaboo'

Plug 'airblade/vim-gitgutter'

Plug 'tpope/vim-fugitive'

Plug 'tpope/vim-surround'

Plug 'tpope/vim-sleuth'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'mg979/vim-visual-multi', {'branch': 'master'}

Plug 'm4xshen/autoclose.nvim'

Plug 'lukas-reineke/indent-blankline.nvim'

Plug 'nvim-lualine/lualine.nvim'

Plug 'ryanoasis/vim-devicons'

Plug 'akinsho/bufferline.nvim'

Plug 'AndrewRadev/splitjoin.vim'

Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

call plug#end()

"""""""""
" theme "
"""""""""

set termguicolors
if $TERMBG == 'light'
    :let &background = 'light'
    colorscheme catppuccin-latte
else
    :let &background = 'dark'
    colorscheme dracula
endif

"""""""""""""""""
" Setup plugins "
"""""""""""""""""

lua require('_autoclose')
lua require('_bufferline')
lua require('_fzf')
lua require('_gitgutter')
lua require('_indentline')
lua require('_lsp')
lua require('_lualine')
lua require('_nerdtree')
