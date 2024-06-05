vim.g.VM_theme = os.getenv('TERMBG') == 'light' and 'lightblue1' or 'purplegray'

require('bufferline').setup{
    highlights = {
        buffer_selected = {
            italic = false,
        },
    },
    options = {
        diagnostics = 'nvim_lsp',
        indicator = {
            style = 'underline',
        },
        style_preset = 'no_italic',
    },
}

vim.api.nvim_set_keymap('n', '<Tab>', ':bn<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<S-Tab>', ':bp<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-X>', ':bd<CR>', { noremap = true })
