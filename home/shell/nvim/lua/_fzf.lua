vim.cmd([[
    command! -bang -nargs=* Rg
        \ call fzf#vim#grep(
        \   'rg --hidden --glob "!.git/" --line-number --color=always --smart-case -- '.shellescape(<q-args>), 1,
        \   fzf#vim#with_preview(), <bang>0)
]])
