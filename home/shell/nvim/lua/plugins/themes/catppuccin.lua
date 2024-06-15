return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  opts = {
    custom_highlights = function(colors)
      return {
        TabLineSel = { bg = colors.pink },
      }
    end,
  },
}
