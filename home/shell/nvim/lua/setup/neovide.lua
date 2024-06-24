vim.o.guifont = 'JetBrainsMono Nerd Font Mono:h12'
vim.g.neovide_cursor_trail_size = 0.5

vim.api.nvim_set_current_dir(vim.fn.expand('~'))
vim.o.autochdir = true

local cpy, pst
if vim.fn.has('macunix') then
  cpy = '<D-c>'
  pst = '<D-v>'
else
  cpy = '<SC-c>'
  pst = '<SC-v>'
end

vim.keymap.set('v', cpy, '"+y', { noremap = true, desc = 'Copy' })
vim.keymap.set('n', pst, '"+p', { noremap = true, desc = 'Paste' })
vim.keymap.set('v', pst, '"+p', { noremap = true, desc = 'Paste' })
vim.keymap.set('c', pst, '<C-o>l<C-o>"+<C-o>P<C-o>l', { noremap = true, desc = 'Paste' })
vim.keymap.set('i', pst, '<ESC>"+pi', { noremap = true, desc = 'Paste' })
vim.keymap.set('t', pst, '<C-\\><C-n>"+Pi', { noremap = true, desc = 'Paste' })

vim.g.neovide_input_macos_option_key_is_meta = 'only_left'
