require('mason').setup()

local servers = {
    gopls = {},
    rust_analyzer = {},
    pyright = {},
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

    tsserver = {},
    html = {},
    cssls = {},

    jsonls = {},
    yamlls = {},
    marksman = {},
}

require('mason-lspconfig').setup({
    ensure_installed = vim.tbl_keys(servers),
    auto_update = false,
    run_on_start = true,
    start_delay = 2000,
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require('lspconfig')
for lsp, config in pairs(servers) do
    lspconfig[lsp].setup {
        capabilities = capabilities,
        settings = config.settings,
    }
end

local cmp = require('cmp')

local kind_icons = {
    Text = "",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = "󰇽",
    Variable = "󰂡",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "󰅲",
}

cmp.setup({
    snippet = {
        expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
        end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
            vim_item.menu = ({
                luasnip = "[SNP]",
                buffer = "[BFR]",
                path = "[PTH]",
            })[entry.source.name]
            return vim_item
        end,
	},
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        -- { name = 'vsnip' }, -- For vsnip users.
        -- { name = 'luasnip' }, -- For luasnip users.
        -- { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'snippy' }, -- For snippy users.
    }, {
        { name = 'buffer' },
    })
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp", { clear = true }),
    callback = function(args)
      	vim.api.nvim_create_autocmd("BufWritePre", {
      	    buffer = args.buf,
      	    callback = function()
      	    	vim.lsp.buf.format { async = false, id = args.data.client_id }
      	    end,
      	})
    end
})

vim.keymap.set({ 'n', 'v' }, '<leader>ca', ':lua vim.lsp.buf.code_action()<CR>', { noremap = true })
vim.keymap.set({ 'n', 'v' }, '<leader>re', ':lua vim.lsp.buf.rename()<CR>', { noremap = true })
