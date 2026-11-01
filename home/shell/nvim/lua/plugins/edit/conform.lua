return {
  'stevearc/conform.nvim',
  dependencies = { 'williamboman/mason.nvim' },
  opts = {
    formatters_by_ft = {
      javascript = { 'prettier' },
      javascriptreact = { 'prettier' },
      typescript = { 'prettier' },
      typescriptreact = { 'prettier' },
      css = { 'prettier' },
      scss = { 'prettier' },
      less = { 'prettier' },
      html = { 'prettier' },
      json = { 'prettier' },
      jsonc = { 'prettier' },
      yaml = { 'prettier' },
      markdown = { 'prettier' },
      sh = { 'shfmt' },
      bash = { 'shfmt' },
    },
    default_format_opts = {
      lsp_format = 'fallback',
    },
    format_on_save = function(bufnr)
      if vim.b[bufnr].format_on_save == false or vim.bo[bufnr].buftype ~= '' then
        return
      end
      return { timeout_ms = 2000 }
    end,
  },
  config = function(_, opts)
    local conform = require('conform')
    conform.setup(opts)

    vim.keymap.set('n', '<leader>cf', function()
      conform.format({ async = true })
    end, { desc = 'Format code' })

    vim.keymap.set('n', '<leader>xf', function()
      vim.b.format_on_save = vim.b.format_on_save == false
      vim.notify(
        'Format on save (buffer ' .. vim.api.nvim_get_current_buf() .. ') is now '
          .. (vim.b.format_on_save and 'enabled' or 'disabled') .. '.',
        'info'
      )
    end, { desc = 'Toggle format on save' })
  end,
}
