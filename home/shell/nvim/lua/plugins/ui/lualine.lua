return {
  'nvim-lualine/lualine.nvim',
  config = function()
    local function get_visual_multi(mode)
      -- local result = vim.fn['VMInfos']()
      -- local ratio = result.ratio
      -- local patterns = result.patterns
      -- local status = result.status
      return 'MULTI (' .. mode .. ') '
      -- .. ' 󱩾 '
      -- .. patterns[1]
      -- .. ' ['
      -- .. ratio
      -- .. ']'
    end

    require('lualine').setup({
      extensions = { 'nerdtree' },
      options = {
        theme = 'auto',
      },
      sections = {
        lualine_a = {
          {
            'mode',
            fmt = function(mode)
              if vim.b['visual_multi'] then
                return get_visual_multi(mode)
              end

              return mode
            end,
          },
        },
      },
    })
  end,
}
