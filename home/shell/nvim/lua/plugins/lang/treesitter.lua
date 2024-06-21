return {
  'nvim-treesitter/nvim-treesitter',
  main = 'nvim-treesitter.configs',
  opts = {
    ensure_installed = {
      'bash',
      'c_sharp',
      'go',
      'nix',
      'python',
      'rust',

      'html',
      'css',
      'javascript',
      'typescript',
      'json',
      'yaml',

      'lua',
      'vimdoc',
    },
    highlight = {
      enable = true,
    },
  },
}
