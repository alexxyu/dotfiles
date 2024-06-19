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
  event = 'VeryLazy',
  config = function()
    local neotest = require('neotest')
    neotest.setup({
      adapters = {
        require('neotest-go'),
        require('neotest-dotnet'),
      },
    })

    vim.keymap.set({ 'n', 'v' }, '<leader>tu', neotest.run.run, { desc = 'Run nearest test' })
    vim.keymap.set({ 'n', 'v' }, '<leader>tt', function()
      return neotest.run.run(vim.fn.expand('%'))
    end, { desc = 'Run tests in file' })
    vim.keymap.set({ 'n', 'v' }, '<leader>tw', function()
      neotest.watch.toggle(vim.fn.expand('%'))
    end, { desc = 'Toggle watch' })

    vim.keymap.set({ 'n', 'v' }, '<leader>to', function()
      neotest.output.open({
        open_win = function()
          vim.cmd('belowright ' .. math.floor(vim.o.lines * 0.33) .. 'split')
        end,
      })
    end, { desc = 'Open test output' })
    vim.keymap.set({ 'n', 'v' }, '<leader>tp', neotest.summary.open, { desc = 'Open test summary' })
  end,
}
