return {
  'mg979/vim-visual-multi',
  branch = 'master',
  init = function()
    vim.g.VM_theme = os.getenv('TERMBG') == 'light' and 'lightblue1' or 'purplegray'
    vim.g.VM_set_statusline = 0
    vim.g.VM_silent_exit = 1
  end,
}
