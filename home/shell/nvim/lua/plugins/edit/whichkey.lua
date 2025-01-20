return {
  'folke/which-key.nvim',
  lazy = true,
  opts = {
    keys = {
      scroll_down = '<C-f>', -- binding to scroll down inside the popup
      scroll_up = '<C-b>', -- binding to scroll up inside the popup
    },
    win = {
      border = 'single',
    },
    filter = function(mapping)
      return mapping.desc and mapping.desc ~= ''
    end,
  },
}
