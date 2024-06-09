local builtins = require('telescope.builtin')

require('telescope').setup {
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown()
    }
  },
  defaults = {
    path_display = {
      filename_first = {
        reverse_directories = false
      },
    },
  },
}

vim.keymap.set('n', '<leader>ff', builtins.find_files, { desc = "Find files" })
vim.keymap.set('n', '<leader>fb', builtins.buffers, { desc = "Find buffers" })
vim.keymap.set('n', '<leader>fr', builtins.registers, { desc = "Find registers" })
vim.keymap.set('n', '<leader>sg', builtins.live_grep, { desc = "Search code" })

vim.keymap.set('n', '<leader>ld', builtins.lsp_definitions, { desc = "All definitions" })
vim.keymap.set('n', '<leader>lo', builtins.lsp_outgoing_calls, { desc = "Outgoing calls" })
vim.keymap.set('n', '<leader>li', builtins.lsp_incoming_calls, { desc = "Incoming calls" })
vim.keymap.set('n', '<leader>lr', builtins.lsp_references, { desc = "All references" })
vim.keymap.set('n', '<leader>lp', builtins.lsp_implementations, { desc = "All implementations" })
vim.keymap.set('n', '<leader>lz', builtins.lsp_document_symbols, { desc = "Document symbols" })
vim.keymap.set('n', '<leader>lx', builtins.lsp_workspace_symbols, { desc = "Workplace symbols" })

require('which-key').register({
  l = { name = "+lsp" },
  f = { name = "+find" },
  s = { name = "+source" },
}, { prefix = "<leader>" })

require('telescope').load_extension('ui-select')
require('telescope').load_extension('fzf')
