return {
  'nvim-treesitter/nvim-treesitter',
  main = 'nvim-treesitter.configs',
  config = {
    ensure_installed = {
      'go',
      'rust',
      'python',
      'nix',

      'html',
      'css',
      'javascript',
      'typescript',
    },
    highlight = {
      enable = true,
    },
  },
};
