return {
  'olexsmir/gopher.nvim',
  ft = 'go',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('gopher').setup({})

    vim.keymap.set('n', '<leader>tg', '<cmd>GoTestAdd<cr>', { desc = 'Generate test for function' })
    vim.keymap.set('n', '<leader>tG', '<cmd>GoTestsAll<cr>', { desc = 'Generate test for file' })
  end,
}
