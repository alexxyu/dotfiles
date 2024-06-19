-------------------------
-- Set indent behavior --
-------------------------
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.backspace = 'indent,eol,start'
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
vim.opt.wrap = false

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
vim.opt.mouse = 'a'
table.insert(vim.opt.ve, 'onemore')
vim.opt.clipboard = 'unnamed,unnamedplus'
vim.opt.encoding = 'utf-8'
vim.opt.updatetime = 300

-- Highlight on yank
vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  group = 'YankHighlight',
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = '1000' })
  end,
})

-- Remove whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '',
  command = ':%s/\\s\\+$//e',
})

-- Enter insert mode when switching to terminal
vim.api.nvim_create_autocmd('TermOpen', {
  command = 'setlocal listchars= nonumber norelativenumber nocursorline',
})

vim.api.nvim_create_autocmd('TermOpen', {
  pattern = '',
  command = 'startinsert',
})

------------------------
-- General keybindings -
------------------------
-- Set leader to space
vim.g.mapleader = ' '

-- Save
vim.keymap.set({ 'n', 's', 'x', 'i' }, '<C-S>', '<CMD>w<CR>', { desc = 'Save' })

-- Quit all
vim.keymap.set('n', '<leader>qq', '<CMD>qa<CR>', { desc = 'Quit all' })

-- Convenient redo
vim.keymap.set('n', 'U', '<C-R>', { noremap = true, desc = 'Redo' })

-- Clear search highlight on <CR>
vim.keymap.set('n', '<CR>', '<Cmd>noh<CR><Bar><Cmd>echon<CR><CR>', { noremap = true })

-- Line navigation
vim.keymap.set('n', '<A-j>', '<cmd>m .+1<cr>==', { noremap = true, silent = true, desc = 'Move line up' })
vim.keymap.set('n', '<A-k>', '<cmd>m .-2<cr>==', { noremap = true, silent = true, desc = 'Move line down' })
vim.keymap.set('i', '<A-j>', '<Esc><cmd>m .+1<cr>==gi', { noremap = true, silent = true, desc = 'Move line up' })
vim.keymap.set('i', '<A-k>', '<Esc><cmd>m .-2<cr>==gi', { noremap = true, silent = true, desc = 'Move line down' })
vim.keymap.set('v', '<A-j>', ":m '>+1<cr>gv=gv", { noremap = true, silent = true, desc = 'Move line up' })
vim.keymap.set('v', '<A-k>', ":m '<-2<cr>gv=gv", { noremap = true, silent = true, desc = 'Move line down' })

-- Split screen navigation
vim.keymap.set('n', '<leader>wr', '<C-W>v', { noremap = true, desc = 'Split right' })
vim.keymap.set('n', '<leader>wb', '<C-W>s', { noremap = true, desc = 'Split below' })
vim.keymap.set('n', '<leader>ww', '<C-W><C-W>', { noremap = true, desc = 'Switch' })
vim.keymap.set('n', '<leader>wt', ':vsplit | term zsh<CR>', { noremap = true, desc = 'Split terminal' })

-------------------
-- Setup plugins --
-------------------

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  { import = 'plugins' },
  { import = 'plugins.edit' },
  { import = 'plugins.themes' },
  { import = 'plugins.ui' },
}, {
  defaults = {
    lazy = false,
  },
  diff = {
    cmd = 'terminal_git',
  },
  install = {
    missing = true,
    colorscheme = { 'catppuccin' },
  },
})

require('which-key').register({
  ['<leader>w'] = { name = '+window' },
  ['<leader>t'] = { name = '+toggle' },
  ['<leader>q'] = { name = '+quit' },
  ['g'] = { name = '+goto' },
  ['z'] = { name = '+fold' },
  ['['] = { name = '+next' },
  [']'] = { name = '+previous' },
})

------------
-- Themes --
------------
vim.termguicolors = true
if os.getenv('TERMBG') == 'light' then
  vim.g.background = 'light'
  vim.cmd('silent! colorscheme catppuccin-latte')
else
  vim.g.background = 'dark'
  vim.cmd('silent! colorscheme catppuccin-macchiato')
end
