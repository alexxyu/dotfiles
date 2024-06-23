vim.o.guifont = 'JetBrainsMono Nerd Font Mono:h12'
vim.g.neovide_cursor_trail_size = 0.5

vim.api.nvim_set_current_dir(vim.fn.expand('~'))
vim.o.autochdir = true

vim.keymap.set('n', '<D-s>', ':w<CR>', { desc = 'Save' })
vim.keymap.set('v', '<D-c>', '"+y', { desc = 'Copy' })
vim.keymap.set('n', '<D-v>', '"+P', { desc = 'Paste' })
vim.keymap.set('v', '<D-v>', '"+P', { desc = 'Paste' })
vim.keymap.set('c', '<D-v>', '<C-R>+', { desc = 'Paste' })
vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli', { desc = 'Paste' })

vim.g.neovide_input_macos_option_key_is_meta = 'only_left'
