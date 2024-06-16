return {
  'goolord/alpha-nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- Inspired by https://github.com/goolord/alpha-nvim/discussions/16#discussioncomment-1309233
    local alpha = require('alpha')
    local dashboard = require('alpha.themes.dashboard')

    dashboard.section.header.val = {
      "                                                    ",
      " ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
      " ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
      " ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
      " ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
      " ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
      " ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
      "                                                    ",
    }

    dashboard.section.buttons.val = {
      dashboard.button('n', '  > New file', '<cmd>ene<cr>'),
      dashboard.button('f', '󰈞  > Find file', '<cmd>Telescope find_files<cr>'),
      dashboard.button('r', '  > Recent', '<cmd>Telescope oldfiles<cr>'),
      dashboard.button('-', '  > File Explorer', '<cmd>Oil<cr>'),
      dashboard.button('l', '󰒲  > Lazy', '<cmd>Lazy<cr>'),
      dashboard.button('m', '󱌣  > Mason', '<cmd>Mason<cr>'),
      dashboard.button('q', '󰩈  > Quit', '<cmd>qa<cr>'),
    }

    alpha.setup(dashboard.opts)

    -- Disable folding on alpha buffer
    vim.cmd([[ autocmd FileType alpha setlocal nofoldenable ]])
  end
}
