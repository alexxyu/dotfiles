return {
  'mfussenegger/nvim-dap',
  dependencies = {},
  keys = '<leader>d',
  config = function()
    local mapping = {
      DapBreakpoint = '',
      DapBreakpointCondition = '',
      DapBreakpointRejected = '',
      DapLogPoint = '◆',
      DapStopped = '󰁕',
    }
    for sign, icon in pairs(mapping) do
      vim.fn.sign_define(sign, { text = icon, texthl = '', linehl = '', numhl = '' })
    end

    vim.keymap.set('n', '<leader>db', require('dap').toggle_breakpoint, { desc = 'Toggle breakpoint' })
    vim.keymap.set('n', '<leader>dc', require('dap').continue, { desc = 'Continue' })
    vim.keymap.set('n', '<leader>di', require('dap').repl.open, { desc = 'Inspect state via repl' })
    vim.keymap.set('n', '<leader>dj', require('dap').step_over, { desc = 'Step over' })
    vim.keymap.set('n', '<leader>dk', require('dap').step_into, { desc = 'Step into' })
    vim.keymap.set('n', '<leader>dm', require('dap').step_out, { desc = 'Step out' })
  end,
}
