return {
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '' },
      topdelete = { text = '' },
      changedelete = { text = '▎' },
      untracked = { text = '▎' },
    },
    current_line_blame = false,
    current_line_blame_opts = {
      virt_text_pos = 'eol',
      delay = 200,
      ignore_whitespace = true,
    },
    on_attach = function(bufnr)
      local gitsigns = require('gitsigns')

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      map('n', ']h', function()
        if vim.wo.diff then
          vim.cmd.normal({ ']h', bang = true })
        else
          gitsigns.nav_hunk('next')
        end
      end, { desc = 'Next hunk' })

      map('n', '[h', function()
        if vim.wo.diff then
          vim.cmd.normal({ '[h', bang = true })
        else
          gitsigns.nav_hunk('prev')
        end
      end, { desc = 'Previous hunk' })

      map('n', '<leader>gs', gitsigns.stage_hunk, { desc = 'Stage hunk' })
      map('n', '<leader>gr', gitsigns.reset_hunk, { desc = 'Reset hunk' })
      map('v', '<leader>gs', function()
        gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, { desc = 'Stage hunk' })
      map('v', '<leader>gr', function()
        gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, { desc = 'Reset hunk' })
      map('n', '<leader>gu', gitsigns.undo_stage_hunk, { desc = 'Undo stage hunk' })

      map('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'Preview hunk' })
      map('n', '<leader>gb', ':Gitsigns toggle_current_line_blame<CR>', { desc = 'Toggle blame' })
    end,
  },
}
