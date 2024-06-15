return {
  'romgrk/barbar.nvim',
  dependencies = {
    'lewis6991/gitsigns.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  init = function() vim.g.barbar_auto_setup = false end,
  config = function()
    require('barbar').setup({
      highlight_inactive_file_icons = true,
      sidebar_filetypes = {
        NvimTree = true,
      },
      icons = {
        preset = 'slanted',
      },
      gitsigns = {
        added = { enabled = true, icon = '+' },
        changed = { enabled = true, icon = '~' },
        deleted = { enabled = true, icon = '' },
      },
    })

    local map = vim.keymap.set
    local function opts(desc)
      return { desc = desc, noremap = true, silent = true, nowait = true }
    end

    map('n', ']b', '<CMD>BufferNext<CR>', opts('Next buffer'))
    map('n', '[b', '<CMD>BufferPrevious<CR>', opts('Previous buffer'))

    map('n', '<A-,>', '<CMD>BufferMovePrevious<CR>', opts('Move buffer left'))
    map('n', '<A-.>', '<CMD>BufferMoveNext<CR>', opts('Move buffer right'))
    map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts('Go to buffer 1'))
    map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts('Go to buffer 2'))
    map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts('Go to buffer 3'))
    map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts('Go to buffer 4'))
    map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts('Go to buffer 5'))
    map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts('Go to buffer 6'))
    map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts('Go to buffer 7'))
    map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts('Go to buffer 8'))
    map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts('Go to buffer 9'))
    map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts('Go to last buffer'))

    map('n', '<leader>bb', '<Cmd>BufferPick<CR>', opts('Pick buffer'))
    map('n', '<leader>bc', '<CMD>BufferClose<CR>', opts("Close buffer"))
    map('n', '<leader>br', '<Cmd>BufferRestore<CR>', opts('Restore buffer'))

    require('which-key').register({
      ['<leader>b'] = { name = '+buffer' },
    })
  end
};
