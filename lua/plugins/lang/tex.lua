return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.highlight = opts.highlight or {} -- extend or instantiate highlights
      opts.ensure_installed = vim.list_extend(opts.ensure_installed or {}, { "bibtex" }) -- add bibtex
      opts.highlight.disable = vim.list_extend(opts.highlight.disable or {}, { "latex" }) -- disable highlight for latex
    end,
  },
  {
    "lervag/vimtex",
    config = function()
      vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- this conflicts with the lsp hover
      vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog" -- use pplatex as the vimtex quickfix
    end,
    keys = {
      { "<localLeader>l", "", desc = "+vimtext" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        texlab = {
          keys = {
            { "<Leader>K", "<plug>(vimtex-doc-package)", desc = "Vimtex Docs", silent = true },
          },
        },
      },
    },
  },
}
