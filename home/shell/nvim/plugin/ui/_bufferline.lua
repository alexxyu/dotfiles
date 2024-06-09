vim.g.VM_theme = os.getenv('TERMBG') == 'light' and 'lightblue1' or 'purplegray'

require('bufferline').setup {
  highlights = {
    buffer_selected = {
      italic = false,
    },
  },
  options = {
    diagnostics = 'nvim_lsp',
    indicator = {
      style = 'underline',
    },
    style_preset = 'no_italic',
  },
}

vim.keymap.set('n', ']b', ':bn<CR>', { noremap = true, desc = "Next buffer" })
vim.keymap.set('n', '[b', ':bp<CR>', { noremap = true, desc = "Previous buffer" })
vim.keymap.set('n', '<C-X>', ':bd<CR>', { noremap = true, desc = "Close buffer" })
