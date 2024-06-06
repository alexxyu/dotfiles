
local builtins = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtins.find_files, {})
vim.keymap.set('n', '<leader>fr', builtins.registers, {})
vim.keymap.set('n', '<leader>sg', builtins.live_grep, {})

vim.keymap.set('n', '<leader>ld', builtins.lsp_definitions, {})
vim.keymap.set('n', '<leader>lo', builtins.lsp_outgoing_calls, {})
vim.keymap.set('n', '<leader>li', builtins.lsp_incoming_calls, {})
vim.keymap.set('n', '<leader>lr', builtins.lsp_references, {})
vim.keymap.set('n', '<leader>lp', builtins.lsp_implementations, {})
vim.keymap.set('n', '<leader>lz', builtins.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>lx', builtins.lsp_workspace_symbols, {})

require('telescope').setup{
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

require('telescope').load_extension('ui-select')
require('telescope').load_extension('fzf')
