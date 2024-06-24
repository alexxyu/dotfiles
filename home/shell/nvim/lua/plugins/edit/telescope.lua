return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'CFLAGS=-march=native make', -- https://github.com/nvim-telescope/telescope-fzf-native.nvim/issues/119#issuecomment-1873653249
    },
    'nvim-telescope/telescope-ui-select.nvim',
    'stevearc/dressing.nvim',
  },
  config = function()
    local builtins = require('telescope.builtin')
    local previewers = require('telescope.previewers')

    require('telescope').setup({
      defaults = {
        path_display = {
          filename_first = {
            reverse_directories = false,
          },
        },
      },
    })

    vim.keymap.set('n', '<leader>fc', builtins.live_grep, { desc = 'Find code' })
    vim.keymap.set('n', '<leader>ff', builtins.find_files, { desc = 'Find files' })
    vim.keymap.set('n', '<leader>fh', builtins.command_history, { desc = 'Find command history' })
    vim.keymap.set('n', '<leader>fr', builtins.registers, { desc = 'Find registers' })

    vim.keymap.set('n', '<leader>ld', builtins.lsp_definitions, { desc = 'All definitions' })
    vim.keymap.set('n', '<leader>lo', builtins.lsp_outgoing_calls, { desc = 'Outgoing calls' })
    vim.keymap.set('n', '<leader>li', builtins.lsp_incoming_calls, { desc = 'Incoming calls' })
    vim.keymap.set('n', '<leader>lr', builtins.lsp_references, { desc = 'All references' })
    vim.keymap.set('n', '<leader>lp', builtins.lsp_implementations, { desc = 'All implementations' })
    vim.keymap.set('n', '<leader>lz', builtins.lsp_document_symbols, { desc = 'Document symbols' })
    vim.keymap.set('n', '<leader>lx', builtins.lsp_workspace_symbols, { desc = 'Workplace symbols' })

    local git_bcommits = function()
      builtins.git_bcommits({
        previewer = previewers.new_termopen_previewer({
          get_command = function(entry)
            return { 'git', '--no-pager', 'show', entry.value .. '^!', '--', entry.current_file }
          end,
        }),
      })
    end

    local git_status = function()
      builtins.git_status({
        previewer = previewers.new_termopen_previewer({
          get_command = function(entry)
            return { 'git', '--no-pager', 'diff', entry.value }
          end,
        }),
      })
    end

    local git_branches = function()
      return builtins.git_branches({
        previewer = previewers.new_termopen_previewer({
          get_command = function(entry)
            return { 'git', 'log', entry.value }
          end,
        }),
        show_remote_tracking_branches = false,
      })
    end

    vim.keymap.set('n', '<leader>fB', git_branches, { desc = 'List git branches' })
    vim.keymap.set('n', '<leader>fC', git_bcommits, { desc = 'List git commits' })
    vim.keymap.set('n', '<leader>fS', git_status, { desc = 'Show git status' })

    require('telescope').load_extension('fzf')
  end,
}
