-------------------------
-- Set indent behavior --
-------------------------
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.backspace = "indent,eol,start"
vim.opt.startofline = false

------------------------
-- Set editor display --
------------------------
vim.opt.ruler = true
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.showmode = true
vim.cmd([[
  " neovim changes the terminal cursor; this respects the cursor on exit
  augroup RestoreCursorShapeOnExit
    autocmd!
    autocmd VimLeave * set guicursor=a:ver1
  augroup END
]])
vim.opt.splitright = true

-------------------------
-- Set search behavior --
-------------------------
vim.cmd('highlight LineNr ctermfg=grey')
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.incsearch = true

------------------------
-- Set other behavior --
------------------------
vim.opt.mouse = "a"
table.insert(vim.opt.ve, "onemore")
vim.opt.clipboard = "unnamed,unnamedplus"
vim.opt.encoding = "utf-8"
vim.opt.updatetime = 300

-- Highlight on yank
vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  group = 'YankHighlight',
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = '1000' })
  end
})

-- Remove whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '',
  command = ":%s/\\s\\+$//e"
})

-- Enter insert mode when switching to terminal
vim.api.nvim_create_autocmd('TermOpen', {
  command = 'setlocal listchars= nonumber norelativenumber nocursorline',
})

vim.api.nvim_create_autocmd('TermOpen', {
  pattern = '',
  command = 'startinsert'
})

------------------------
-- General keybindings -
------------------------
-- Set leader to space
vim.g.mapleader = " "

-- Convenient redo
vim.keymap.set('n', 'U', '<C-R>', { noremap = true })

-- Clear search highlight on <CR>
vim.keymap.set('n', '<CR>', '<Cmd>noh<CR><Bar><Cmd>echon<CR><CR>', { noremap = true })

-- Line navigation
vim.keymap.set('n', '<A-j>', '<cmd>m .+1<cr>==', { noremap = true, silent = true })
vim.keymap.set('n', '<A-k>', '<cmd>m .-2<cr>==', { noremap = true, silent = true })
vim.keymap.set('i', '<A-j>', '<Esc><cmd>m .+1<cr>==gi', { noremap = true, silent = true })
vim.keymap.set('i', '<A-k>', '<Esc><cmd>m .-2<cr>==gi', { noremap = true, silent = true })
vim.keymap.set('v', '<A-j>', ":m '>+1<cr>gv=gv", { noremap = true, silent = true })
vim.keymap.set('v', '<A-k>', ":m '<-2<cr>gv=gv", { noremap = true, silent = true })

-- Split screen navigation
vim.keymap.set('n', '<leader>wr', '<C-W>v<CR>', { noremap = true })
vim.keymap.set('n', '<leader>wb', '<C-W>s<CR>', { noremap = true })
vim.keymap.set('n', '<leader>ww', '<C-W><C-W><CR>', { noremap = true })
vim.keymap.set('n', '<leader>wt', ':vsplit | term zsh<CR>', { noremap = true })

-------------------
-- Setup plugins --
-------------------
vim.cmd([[
  let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
  if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
]])

local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug('catppuccin/nvim', { ['as'] = 'catppuccin' })
Plug('dracula/vim', { ['as'] = 'dracula' })

Plug('ryanoasis/vim-devicons')
Plug('preservim/nerdtree')

Plug('nvim-tree/nvim-web-devicons')
Plug('SmiteshP/nvim-navic')
Plug('b0o/incline.nvim')

Plug('lewis6991/gitsigns.nvim')
Plug('tpope/vim-fugitive')
Plug('tpope/vim-surround')
Plug('tpope/vim-sleuth')
Plug('tpope/vim-rsi')
Plug('AndrewRadev/splitjoin.vim')

Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'CFLAG=-march=native make' })
Plug('nvim-telescope/telescope.nvim')
Plug('nvim-telescope/telescope-ui-select.nvim')

Plug('mg979/vim-visual-multi', { ['branch'] = 'master' })
Plug('m4xshen/autoclose.nvim')
Plug('lukas-reineke/indent-blankline.nvim')

Plug('nvim-lualine/lualine.nvim')
Plug('akinsho/bufferline.nvim')

Plug('nvim-treesitter/nvim-treesitter')
Plug('windwp/nvim-ts-autotag')
Plug('williamboman/mason.nvim')
Plug('williamboman/mason-lspconfig.nvim')
Plug('neovim/nvim-lspconfig')

Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/cmp-cmdline')
Plug('hrsh7th/nvim-cmp')

vim.call('plug#end')

require('_autoclose')
require('_bufferline')
require('_gitsigns')
require('_incline')
require('_indentline')
require('_lsp')
require('_lualine')
require('_nerdtree')
require('_telescope')
require('_treesitter')

------------
-- Themes --
------------
vim.termguicolors = true
if os.getenv('TERMBG') == 'light' then
  vim.g.background = 'light'
  vim.cmd('silent! colorscheme catppuccin-latte')
else
  vim.g.background = 'dark'
  vim.cmd('silent! colorscheme dracula')
end
