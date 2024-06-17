return {
  'ggandor/leap.nvim',
  config = function()
    vim.keymap.set({ 'n', 'o' }, 's', '<Plug>(leap-forward)', { desc = 'Leap forward' })
    vim.keymap.set({ 'n', 'o' }, 'S', '<Plug>(leap-backward)', { desc = 'Leap backward' })
    vim.keymap.set({ 'n', 'o' }, 'gs', '<Plug>(leap-from-window)', { desc = 'Leap from window' })
    vim.keymap.set({ 'x' }, 'z', '<Plug>(leap-forward)', { desc = 'Leap forward' })
    vim.keymap.set({ 'x' }, 'Z', '<Plug>(leap-backward)', { desc = 'Leap backward' })
    vim.keymap.set({ 'x' }, 'gz', '<Plug>(leap-from-window)', { desc = 'Leap from window' })

    require('leap.user').set_repeat_keys(']', '[')
  end,
}
