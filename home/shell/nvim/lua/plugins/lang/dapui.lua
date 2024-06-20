return {
  'rcarriga/nvim-dap-ui',
  dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
  keys = '<leader>d',
  init = function()
    vim.keymap.set({ 'n', 'v' }, '<leader>dd', function()
      require('dapui').toggle()
    end, { desc = 'Toggle dap-ui' })
  end,
  opts = {},
}
