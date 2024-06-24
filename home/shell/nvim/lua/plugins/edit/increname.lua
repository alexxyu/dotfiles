return {
  'smjonas/inc-rename.nvim',
  config = function()
    require('inc_rename').setup()
    vim.keymap.set({ 'n', 'v' }, '<leader>cr', ':IncRename ', { desc = 'Rename symbol' })
  end,
}
