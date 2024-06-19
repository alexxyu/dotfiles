require('mason-tool-installer').setup({
  ensure_installed = {
    'prettier',
    'shellcheck',
    'shfmt',
  },
})

-- Define LSP servers + configurations to install and set up
local servers = {
  gopls = {
    settings = {
      gopls = {
        hints = {
          assignVariableTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
    },
  },

  ruff_lsp = {},
  pyright = {
    settings = {
      pyright = {
        -- Using Ruff's import organizer
        disableOrganizeImports = true,
      },
      python = {
        analysis = {
          -- Ignore all files for analysis to exclusively use Ruff for linting
          ignore = { '*' },
        },
      },
    },
  },

  nil_ls = {
    settings = {
      ['nil'] = {
        diagnostics = {
          ignored = { 'unused_binding', 'unused_with' },
        },
        formatting = {
          command = { 'nixfmt' },
        },
      },
    },
  },

  lua_ls = {},
  bashls = {
    -- >.< shellcheck refuses to check zsh: https://github.com/bash-lsp/bash-language-server/issues/1064
    filetypes = { 'zsh', 'sh' },
    bashIde = {
      shellcheckArguments = '--shell=bash',
    },
  },
  omnisharp = {},
  rust_analyzer = {},

  cssls = {},
  eslint = {},
  html = {},

  tsserver = {
    settings = {
      javascript = {
        inlayHints = {
          includeInlayEnumMemberValueHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayVariableTypeHints = true,
        },
      },
      typescript = {
        inlayHints = {
          includeInlayEnumMemberValueHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayVariableTypeHints = true,
        },
      },
    },
  },

  jsonls = {},
  yamlls = {
    settings = {
      yaml = {
        validate = true,
        hover = true,
        completion = true,
        schemas = {
          ['https://json.schemastore.org/github-workflow'] = '.github/workflows/*.{yml,yaml}',
          ['http://json.schemastore.org/github-action'] = '.github/action.{yml,yaml}',
          ['https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json'] = '*-compose.{yml,yaml}',
        },
      },
    },
  },
  marksman = {},
}

-- Install and set up LSP servers
require('mason-lspconfig').setup({
  ensure_installed = vim.tbl_keys(servers),
  auto_update = false,
  run_on_start = true,
  start_delay = 2000,
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')
local navic = require('nvim-navic')

for lsp, config in pairs(servers) do
  lspconfig[lsp].setup(vim.tbl_extend('force', {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
      end
    end,
  }, config))
end

-- Set up capabilities on LSP attach
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp', { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end

    vim.keymap.set('n', '<leader><Space>', vim.lsp.buf.hover, { desc = 'Display hover info' })
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { desc = 'Show code actions' })
    vim.keymap.set({ 'n', 'v' }, '<leader>cr', vim.lsp.buf.rename, { desc = 'Rename symbol' })

    vim.keymap.set(
      { 'n', 'v' },
      '<leader>cd',
      vim.diagnostic.open_float,
      { desc = 'Show diagnostics for current line' }
    )
    vim.keymap.set('n', '<leader>td', function()
      if vim.diagnostic.is_enabled({ bufnr = bufnr }) then
        vim.diagnostic.enable(false, { bufnr = bufnr })
        vim.notify('Diagnostics (buffer ' .. bufnr .. ') are now disabled.', 'info')
      else
        vim.diagnostic.enable(true, { bufnr = bufnr })
        vim.notify('Diagnostics (buffer ' .. bufnr .. ') are now enabled.', 'info')
      end
    end, { desc = 'Toggle diagnostics', buffer = bufnr })

    -- format code
    if client.server_capabilities.documentFormattingProvider then
      vim.keymap.set('n', '<leader>cf', function()
        vim.lsp.buf.format({ async = true, bufnr = bufnr })
      end, { desc = 'Format code', buffer = bufnr })

      vim.keymap.set('n', '<leader>tf', function()
        vim.b.format_on_save = not vim.b.format_on_save
        vim.notify(
          'Format on save (buffer ' .. bufnr .. ') is now ' .. (vim.b.format_on_save and 'enabled' or 'disabled') .. '.',
          'info'
        )
      end, { desc = 'Toggle format on save', buffer = bufnr })

      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = args.buf,
        callback = function()
          if vim.b.format_on_save then
            vim.lsp.buf.format({ async = false })
          end
        end,
      })

      vim.b.format_on_save = true
    end

    -- document highlighting
    if client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_augroup('lsp_document_highlight', {
        clear = false,
      })
      vim.api.nvim_clear_autocmds({
        buffer = bufnr,
        group = 'lsp_document_highlight',
      })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        group = 'lsp_document_highlight',
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        group = 'lsp_document_highlight',
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
    end

    -- inlay hints
    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

      vim.keymap.set('n', '<leader>th', function()
        local value = not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
        vim.lsp.inlay_hint.enable(value, { bufnr = bufnr })
        vim.notify('Inlay hints (buffer' .. bufnr .. ') are now ' .. (value and 'enabled' or 'disabled') .. '.', 'info')
      end, { desc = 'Toggle inlay hints', buffer = bufnr })
    end

    -- codelens support
    if client.server_capabilities.codeLensProvider then
      vim.lsp.codelens.refresh({ bufnr = bufnr })
      vim.api.nvim_create_autocmd({ 'TextChanged', 'InsertLeave', 'CursorHold', 'LspAttach' }, {
        buffer = bufnr,
        callback = function()
          vim.lsp.codelens.refresh({ bufnr = bufnr })
        end,
      })
      vim.keymap.set(
        { 'n', 'v' },
        '<leader>cl',
        ':lua vim.lsp.codelens.run()<CR>',
        { noremap = true, desc = 'Run codelens' }
      )
    end
  end,
})

-- Notification for LSP progress
vim.lsp.handlers['$/progress'] = function(_, result, ctx)
  local notifs = require('lib.notifs')
  local client_id = ctx.client_id

  local val = result.value

  if not val.kind then
    return
  end

  local notif_data = notifs.get_notif_data(client_id, result.token)

  if val.kind == 'begin' then
    local message = notifs.format_message(val.message, val.percentage)

    notif_data.notification = vim.notify(message, 'info', {
      title = notifs.format_title(val.title, vim.lsp.get_client_by_id(client_id).name),
      icon = notifs.spinner_frames[1],
      hide_from_history = false,
    })

    notif_data.spinner = 1
    notifs.update_spinner(client_id, result.token)
  elseif val.kind == 'report' and notif_data then
    notif_data.notification = vim.notify(notifs.format_message(val.message, val.percentage), 'info', {
      replace = notif_data.notification,
      hide_from_history = false,
    })
  elseif val.kind == 'end' and notif_data then
    notif_data.notification = vim.notify(val.message and notifs.format_message(val.message) or 'Complete', 'info', {
      icon = '',
      replace = notif_data.notification,
    })

    notif_data.spinner = nil
  end
end

-- Notifications for messages sent by LSP
vim.lsp.handlers['window/showMessage'] = function(_, result, ctx)
  local severity = {
    'ERROR',
    'WARN',
    'INFO',
    'DEBUG',
  }
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  local lvl = severity[result.type]
  vim.notify(result.message, lvl, {
    title = 'LSP | ' .. (client and client.name or 'nil'),
    keep = function()
      return lvl == 'ERROR' or lvl == 'WARN'
    end,
  })
end

local border = {
  { '🭽', 'FloatBorder' },
  { '▔', 'FloatBorder' },
  { '🭾', 'FloatBorder' },
  { '▕', 'FloatBorder' },
  { '🭿', 'FloatBorder' },
  { '▁', 'FloatBorder' },
  { '🭼', 'FloatBorder' },
  { '▏', 'FloatBorder' },
}

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or border
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

require('which-key').register({
  c = { name = '+code' },
}, { prefix = '<leader>' })
