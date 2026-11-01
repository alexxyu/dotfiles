return {
  'rmagatti/auto-session',
  init = function()
    vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
  end,
  opts = {
    log_level = 'error',
    auto_save = true,
    auto_restore = false,
    bypass_save_filetypes = {
      'gitcommit',
      'alpha',
    },
    suppressed_dirs = {
      '~',
      '/',
    },
  },
  config = function(_, opts)
    require('auto-session').setup(opts)

    vim.keymap.set('n', '<leader>fs', '<cmd>AutoSession search<cr>', { desc = 'Find session' })
    vim.keymap.set('n', '<leader>qs', '<cmd>AutoSession save<cr>', { desc = 'Save session' })
    vim.keymap.set('n', '<leader>qr', '<cmd>AutoSession restore<cr>', { desc = 'Restore session' })
    vim.keymap.set('n', '<leader>qd', '<cmd>AutoSession delete<cr>', { desc = 'Delete session' })
  end,
}
