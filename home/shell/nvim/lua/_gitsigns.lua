require('gitsigns').setup{
    signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
        untracked    = { text = "▎" },
    },
    word_diff = true,
    current_line_blame = false,
    current_line_blame_opts = {
        virt_text_pos = 'eol',
        delay = 200,
        ignore_whitespace = true,
    },
}

vim.keymap.set('n', '<leader>bl', ':Gitsigns toggle_current_line_blame<CR>', {})
