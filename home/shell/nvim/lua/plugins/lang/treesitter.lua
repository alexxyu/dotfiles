return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  opts = {
    ensure_installed = {
      'bash',
      'c_sharp',
      'go',
      'nix',
      'python',
      'rust',

      'html',
      'css',
      'javascript',
      'typescript',
      'json',
      'yaml',

      'lua',
      'vimdoc',
    },
  },
  config = function(_, opts)
    local treesitter = require('nvim-treesitter')
    treesitter.setup({})
    treesitter.install(opts.ensure_installed)

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('TreesitterHighlight', { clear = true }),
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
        if lang and vim.treesitter.language.add(lang) then
          vim.treesitter.start(args.buf, lang)
        end
      end,
    })
  end,
}
