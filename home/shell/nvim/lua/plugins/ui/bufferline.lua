return {
  'akinsho/bufferline.nvim',
  config = function()
    local bufferline = require('bufferline')
    bufferline.setup({
      options = {
        diagnostics = 'nvim_lsp',
        indicator = {
          style = 'underline',
        },
        style_preset = bufferline.style_preset.no_italic,
        separator_style = 'slant',
        themable = false,
        offsets = {
          { filetype = 'NvimTree' },
        },
      },
    })

    local map = vim.keymap.set
    local function opts(desc)
      return { desc = desc, noremap = true, silent = true, nowait = true }
    end

    map('n', ']b', '<CMD>BufferLineCycleNext<CR>', opts('Next buffer'))
    map('n', '[b', '<CMD>BufferLineCyclePrev<CR>', opts('Previous buffer'))

    map('n', '<A-.>', '<CMD>BufferLineMoveNext<CR>', opts('Move buffer right'))
    map('n', '<A-,>', '<CMD>BufferLineMovePrev<CR>', opts('Move buffer left'))

    for n = 1, 9 do
      map('n', '<A-' .. n .. '>', function()
        bufferline.go_to_buffer(n, true)
      end, opts('Go to buffer ' .. n))
    end

    map('n', '<leader>bb', '<Cmd>BufferLinePick<CR>', opts('Pick buffer'))
    map('n', '<leader>bc', '<Cmd>bdelete<CR>', opts('Close buffer'))

    require('which-key').register({
      ['<leader>b'] = { name = '+buffer' },
    })
  end,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
}
