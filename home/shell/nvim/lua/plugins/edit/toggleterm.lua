local toggle_term_cmd
toggle_term_cmd = function(config)
  -- Credit to https://github.com/catgoose/nvim
  if not config or not config.count then
    return
  end
  if config.cmd[1] ~= nil then
    vim.ui.select(config.cmd, {
      prompt = 'Select command',
    }, function(selected)
      if not selected then
        return
      end
      config.cmd = selected
      toggle_term_cmd(config)
    end)
  else
    local Terminal = require('toggleterm.terminal').Terminal
    local term = Terminal:new(config)
    term:toggle()
  end
end

return {
  'akinsho/toggleterm.nvim',
  opts = {
    shade_terminals = false,
    size = function(term)
      if term.direction == 'horizontal' then
        return math.floor(vim.o.lines / 3)
      elseif term.direction == 'vertical' then
        return math.floor(vim.o.columns / 3)
      end
    end,
    open_mapping = [[<A-`>]],
    float_opts = {
      border = 'curved',
      width = math.floor(vim.o.columns * 0.8),
      height = math.floor(vim.o.lines * 0.8),
      winblend = 3,
    },
    winbar = {
      enabled = true,
      name_formatter = function(term)
        return term.name
      end,
    },
  },
  config = function(_, opts)
    require('toggleterm').setup(opts)

    vim.keymap.set(
      'n',
      '<leader>wt',
      '<cmd>ToggleTerm direction=horizontal<cr>',
      { desc = 'Toggle terminal (horizontal)' }
    )
    vim.keymap.set('n', '<leader>wT', '<cmd>ToggleTerm direction=vertical<cr>', { desc = 'Toggle terminal (vertical)' })

    vim.keymap.set('n', '<leader>wD', function()
      toggle_term_cmd({ count = 5, cmd = 'lazydocker', direction = 'float' })
    end, { desc = 'New terminal: lazydocker' })

    vim.keymap.set('n', '<leader>wR', function()
      toggle_term_cmd({ count = 6, cmd = { 'bpython', 'node', 'ts-node', 'zsh' }, direction = 'float' })
    end, { desc = 'New terminal: REPL' })
  end,
}
