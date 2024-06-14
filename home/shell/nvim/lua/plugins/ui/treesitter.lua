return {
  'nvim-treesitter/nvim-treesitter',
  main = 'nvim-treesitter.configs',
  opts = {
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
