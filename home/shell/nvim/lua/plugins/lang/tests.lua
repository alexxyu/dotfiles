return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',

    'nvim-neotest/neotest-go',
    'Issafalcon/neotest-dotnet',
  },
  keys = '<leader>t',
  config = function()
    local neotest = require('neotest')
    neotest.setup({
      adapters = {
        require('neotest-go'),
        require('neotest-dotnet'),
      },
      icons = {
        passed = '',
        running = '',
        failed = '',
        unknown = '',
      },
    })

    vim.keymap.set({ 'n', 'v' }, '<leader>tu', function()
      neotest.output_panel.clear()
      neotest.run.run()
    end, { desc = 'Run nearest test' })
    vim.keymap.set({ 'n', 'v' }, '<leader>tt', function()
      neotest.output_panel.clear()
      return neotest.run.run(vim.fn.expand('%'))
    end, { desc = 'Run tests in file' })
    vim.keymap.set({ 'n', 'v' }, '<leader>tw', function()
      neotest.watch.toggle(vim.fn.expand('%'))
    end, { desc = 'Toggle watch' })

    vim.keymap.set({ 'n', 'v' }, '<leader>td', function()
      neotest.output_panel.clear()
      neotest.run.run({ strategy = 'dap' })
    end, { desc = 'Test with debugger' })

    vim.keymap.set({ 'n', 'v' }, '<leader>to', neotest.output_panel.toggle, { desc = 'Toggle test output' })
    vim.keymap.set({ 'n', 'v' }, '<leader>tp', neotest.summary.open, { desc = 'Open test summary' })

    require('which-key').register({
      ['<leader>t'] = { name = '+test' },
    })
  end,
}
