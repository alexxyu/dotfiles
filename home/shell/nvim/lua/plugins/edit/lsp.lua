return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason-lspconfig.nvim' },
    { 'williamboman/mason.nvim' },
  },
  config = function()
    require('setup.lsp')
  end
};
