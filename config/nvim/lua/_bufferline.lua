vim.g.VM_theme = os.getenv('TERM_BG') == '' and 'lightblue1' or 'purplegray'

require('bufferline').setup{
    highlights = {
        buffer_selected = {
            italic = false,
        },
    },
    options = {
        diagnostics = 'coc',
        indicator = {
            style = 'underline',
        },
        style_preset = 'no_italic',
    },
}

