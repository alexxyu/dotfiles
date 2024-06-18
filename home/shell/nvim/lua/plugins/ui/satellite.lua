return {
  'lewis6991/satellite.nvim',
  opts = {
    width = 2,
    handlers = {
      cursor = {
        enable = true,
        symbols = { '' },
      },
      diagnostic = {
        enable = true,
        signs = { 'ˈ', '¦', '│' },
      },
      gitsigns = {
        enable = true,
      },
      quickfix = {
        signs = { 'ˈ', '¦', '│' },
      },
    },
  },
}
