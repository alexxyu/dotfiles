return {
  'hrsh7th/nvim-cmp',
  commit = '*',
  dependencies = {
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-cmdline' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-path' },
  },
  config = function()
    require('setup.cmp')
  end,
}
