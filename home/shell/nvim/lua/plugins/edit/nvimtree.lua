return {
  'nvim-tree/nvim-tree.lua',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('nvim-tree').setup({
      filters = {
        dotfiles = true,
      },
      renderer = {
        icons = {
          git_placement = 'after',
          glyphs = {
            git = {
              unstaged = '!',
              staged = '+',
              unmerged = '',
              renamed = '➜',
              deleted = '',
              untracked = '?',
              ignored = '-',
            },
          },
        },
      },
      diagnostics = {
        enable = true,
        debounce_delay = 100,
      },
    })

    -- https://github.com/nvim-tree/nvim-tree.lua/issues/1368#issuecomment-1195557960
    vim.api.nvim_create_autocmd('BufEnter', {
      group = vim.api.nvim_create_augroup('NvimTreeClose', { clear = true }),
      pattern = 'NvimTree_*',
      callback = function()
        local layout = vim.api.nvim_call_function('winlayout', {})
        if
          layout[1] == 'leaf'
          and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), 'filetype') == 'NvimTree'
          and layout[3] == nil
        then
          vim.cmd('confirm quit')
        end
      end,
    })

    local function opts(desc)
      return { desc = 'nvim-tree: ' .. desc, noremap = true, silent = true, nowait = true }
    end

    vim.keymap.set('n', '<leader>nt', ':NvimTreeToggle<CR>', opts('Toggle'))
    vim.keymap.set('n', '<leader>nf', ':NvimTreeFocus<CR>', opts('Focus'))

    require('which-key').register({
      n = { name = '+nvim-tree' },
    }, { prefix = '<leader>' })
  end,
}
