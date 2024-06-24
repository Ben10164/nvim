return {
  {
    "VPavliashvili/json-nvim", -- requires jq (installed with mason later)
    ft = "json",
    keys = {
      { "<localleader>f", "<cmd>JsonFormatFile<cr>", ft = "json", desc = "format json with jq" },
      { "<localleader>m", "<cmd>JsonMinifyFile<cr>", ft = "json", desc = "minify json with jq" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "json5", "jq" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jsonls = {
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              format = {
                enable = true,
              },
              validate = { enable = true },
            },
          },
        },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "jq",
      })
    end,
  },
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false,
  },
}
