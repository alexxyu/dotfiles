return {
  'stevearc/oil.nvim',
  config = function()
    require('oil').setup({
      columns = {
        'icon',
        'permissions',
      },
      delete_to_trash = true,
    })

    vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
  end,
  -- Optional dependencies
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}
