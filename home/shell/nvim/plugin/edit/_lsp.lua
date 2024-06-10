require('mason').setup {
  ensure_installed = {
    'prettier'
  },
}

local servers = {
  gopls = {
    settings = {
      codelenses = {
        generate = true,
        test = true,
        tidy = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },

  omnisharp = {},

  rust_analyzer = {},

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
    }
  },

  nil_ls = {
    settings = {
      ['nil'] = {
        diagnostics = {
          ignored = { "unused_binding", "unused_with" },
        },
        formatting = {
          command = { "nixfmt" },
        },
      },
    },
  },

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
          includeInlayParameterNameHints = "all",
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
          includeInlayParameterNameHints = "all",
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
          ['https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json'] =
          '*-compose.{yml,yaml}',
        },
      },
    },
  },
  marksman = {},
}

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
  lspconfig[lsp].setup {
    capabilities = capabilities,
    settings = config.settings,
    on_attach = function(client, bufnr)
      if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
      end
    end
  }
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp", { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end

    vim.keymap.set({ 'n', 'v' }, '<leader>ca', ':lua vim.lsp.buf.code_action()<CR>',
      { noremap = true, desc = "Code action" })
    vim.keymap.set({ 'n', 'v' }, '<leader>cr', ':lua vim.lsp.buf.rename()<CR>',
      { noremap = true, desc = "Rename symbol" })

    if client.server_capabilities.documentFormattingProvider then
      vim.keymap.set('n', '<leader>cf', function()
        vim.lsp.buf.format { async = true }
      end, { desc = "Format code" })
    end

    -- document highlighting
    if client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_augroup("lsp_document_highlight", {
        clear = false,
      })
      vim.api.nvim_clear_autocmds({
        buffer = bufnr,
        group = "lsp_document_highlight",
      })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = "lsp_document_highlight",
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        group = "lsp_document_highlight",
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
    end

    -- inlay hints
    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
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
      vim.keymap.set({ 'n', 'v' }, '<leader>cl', ':lua vim.lsp.codelens.run()<CR>',
        { noremap = true, desc = "Run codelens" })
    end
  end
})

require('which-key').register({
  c = { name = "+code" }
}, { prefix = "<leader>" })
