return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-cmdline' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-path' },
    { 'SergioRibera/cmp-dotenv' },
    { 'saadparwaiz1/cmp_luasnip' },
  },
  event = 'VeryLazy',
  config = function()
    require('setup.cmp')
  end,
}
