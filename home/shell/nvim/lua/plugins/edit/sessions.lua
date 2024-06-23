return {
  'rmagatti/auto-session',
  init = function()
    vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
  end,
  opts = {
    log_level = 'error',
    auto_save_enabled = true,
    auto_restore_enabled = false,
    bypass_session_save_file_types = {
      'gitcommit',
      'alpha',
    },
    auto_session_suppress_dirs = {
      '~',
      '/',
    },
  },
  config = function(_, opts)
    require('auto-session').setup(opts)

    vim.keymap.set('n', '<leader>fs', require('auto-session.session-lens').search_session, { desc = 'Find session' })
    vim.keymap.set('n', '<leader>qs', '<cmd>SessionSave<cr>', { desc = 'Save session' })
    vim.keymap.set('n', '<leader>qr', '<cmd>SessionRestore<cr>', { desc = 'Restore session' })
    vim.keymap.set('n', '<leader>qd', '<cmd>SessionDelete<cr>', { desc = 'Delete session' })
  end,
}
