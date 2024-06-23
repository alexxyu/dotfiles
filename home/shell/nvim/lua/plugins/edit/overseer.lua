return {
  'stevearc/overseer.nvim',
  init = function()
    -- https://github.com/stevearc/overseer.nvim/blob/master/doc/recipes.md#restart-last-task
    vim.api.nvim_create_user_command('OverseerRestartLast', function()
      local overseer = require('overseer')
      local tasks = overseer.list_tasks({ recent_first = true })
      if vim.tbl_isempty(tasks) then
        vim.notify('No tasks found', vim.log.levels.WARN)
      else
        overseer.run_action(tasks[1], 'restart')
      end
    end, { desc = 'Restart last task' })

    vim.keymap.set('n', '<leader>ra', '<cmd>OverseerTaskAction<cr>', { desc = 'Task actions' })
    vim.keymap.set('n', '<leader>rl', '<cmd>OverseerToggle<cr>', { desc = 'List tasks' })
    vim.keymap.set('n', '<leader>rr', '<cmd>OverseerRestartLast<cr>', { desc = 'Restart last task' })
    vim.keymap.set('n', '<leader>rt', '<cmd>OverseerRun<cr>', { desc = 'Run task' })
  end,
  opts = {
    strategy = {
      'toggleterm',
      direction = 'horizontal',
      auto_scroll = true,
      open_on_start = true,
      quit_on_exit = 'never',
    },
    task_list = {
      direction = 'right',
      max_width = { 40, 0.33 },
      min_width = 15,
    },
  },
}
