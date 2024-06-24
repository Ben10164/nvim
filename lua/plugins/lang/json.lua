return {
  {
    "VPavliashvili/json-nvim", -- requires jq (installed with mason later)
    ft = "json",
    keys = {
      { "<localleader>e", "<cmd>JsonEscapeFile<cr>", ft = "json", desc = "Escape JSON in entire file" },
      { "<localleader>E", "<cmd>JsonEscapeSelection<cr>", ft = "json", desc = "Escape JSON in selected text" },
      { "<localleader>f", "<cmd>JsonFormatFile<cr>", ft = "json", desc = "Format JSON in entire file" },
      { "<localleader>F", "<cmd>JsonFormatSelection<cr>", ft = "json", desc = "Format JSON in selected text" },
      { "<localleader>t", "<cmd>JsonFormatToken<cr>", ft = "json", desc = "Format JSON token under cursor" },
      { "<localleader>c", "<cmd>JsonKeysToCamelCase<cr>", ft = "json", desc = "Convert JSON keys to camelCase" },
      { "<localleader>p", "<cmd>JsonKeysToPascalCase<cr>", ft = "json", desc = "Convert JSON keys to PascalCase" },
      { "<localleader>s", "<cmd>JsonKeysToSnakeCase<cr>", ft = "json", desc = "Convert JSON keys to snake_case" },
      { "<localleader>m", "<cmd>JsonMinifyFile<cr>", ft = "json", desc = "Minify JSON in entire file" },
      { "<localleader>M", "<cmd>JsonMinifySelection<cr>", ft = "json", desc = "Minify JSON in selected text" },
      { "<localleader>u", "<cmd>JsonUnescapeFile<cr>", ft = "json", desc = "Unescape JSON in entire file" },
      { "<localleader>U", "<cmd>JsonUnescapeSelection<cr>", ft = "json", desc = "Unescape JSON in selected text" },
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
