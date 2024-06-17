return {
  'lukas-reineke/indent-blankline.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  main = 'ibl',
  opts = {
    scope = {
      highlight = { 'Label' },
      show_start = false,
      show_end = false,
    },
  },
}
