return {
  'brenoprata10/nvim-highlight-colors',
  init = function()
    vim.keymap.set('n', '<leader>xc', '<cmd>HighlightColors Toggle<cr>', { desc = 'Toggle highlight colors' })
  end,
  opts = {},
}
