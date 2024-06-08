vim.cmd([[
    command! -bang -nargs=* Rg
        \ call fzf#vim#grep(
        \   'rg --hidden --glob "!.git/" --line-number --color=always --smart-case -- '.shellescape(<q-args>), 1,
        \   fzf#vim#with_preview(), <bang>0)
]])

vim.keymap.set('n', '<leader>ff', ':Files<CR>', { noremap = true })
vim.keymap.set('n', '<leader>fl', ':Lines<CR>', { noremap = true })
vim.keymap.set('n', '<leader>cs', ':Rg<CR>', { noremap = true })
