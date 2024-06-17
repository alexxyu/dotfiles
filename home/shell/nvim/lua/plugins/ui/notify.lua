return {
  'rcarriga/nvim-notify',
  dependencies = { 'nvim-telescope/telescope.nvim' },
  init = function()
    vim.notify = require('notify')
    vim.keymap.set('n', '<leader>fn', '<cmd>Telescope notify<cr>', { desc = 'Find notifications' })
  end,
  opts = {
    timeout = 3000,
    stages = 'fade',
    render = 'wrapped-compact',
    fps = 60,
  },
}
