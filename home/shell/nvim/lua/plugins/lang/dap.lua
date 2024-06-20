return {
  'mfussenegger/nvim-dap',
  dependencies = {
    { 'leoluz/nvim-dap-go', opts = {} },
  },
  keys = '<leader>d',
  config = function()
    local dap = require('dap')

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

    dap.adapters.delve = {
      type = 'server',
      port = '${port}',
      executable = {
        command = 'dlv',
        args = { 'dap', '-l', '127.0.0.1:${port}' },
        -- add this if on windows, otherwise server won't open successfully
        -- detached = false
      },
    }

    -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
    dap.configurations.go = {
      {
        type = 'delve',
        name = 'Debug',
        request = 'launch',
        program = '${file}',
      },
      {
        type = 'delve',
        name = 'Debug test', -- configuration for debugging test files
        request = 'launch',
        mode = 'test',
        program = '${file}',
      },
      {
        type = 'delve',
        name = 'Debug test (go.mod)',
        request = 'launch',
        mode = 'test',
        program = './${relativeFileDirname}',
      },
    }

    vim.keymap.set('n', '<leader>db', require('dap').toggle_breakpoint, { desc = 'Toggle breakpoint' })
    vim.keymap.set('n', '<leader>dc', require('dap').continue, { desc = 'Continue' })
    vim.keymap.set('n', '<leader>di', require('dap').repl.open, { desc = 'Inspect state via repl' })
    vim.keymap.set('n', '<leader>dj', require('dap').step_over, { desc = 'Step over' })
    vim.keymap.set('n', '<leader>dk', require('dap').step_into, { desc = 'Step into' })
    vim.keymap.set('n', '<leader>dm', require('dap').step_out, { desc = 'Step out' })

    require('which-key').register({
      ['<leader>d'] = { name = '+debug' },
    })
  end,
}
