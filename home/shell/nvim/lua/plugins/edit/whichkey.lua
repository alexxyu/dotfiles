return {
  'folke/which-key.nvim',
  tag = 'v1.4.3', -- https://github.com/folke/which-key.nvim/issues/482
  lazy = true,
  opts = {
    popup_mappings = {
      scroll_down = '<C-f>', -- binding to scroll down inside the popup
      scroll_up = '<C-b>', -- binding to scroll up inside the popup
    },
    window = {
      border = 'single',
    },
    ignore_missing = false, -- broken until v2.0.0
  },
}
