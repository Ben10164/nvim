return {
  {
    "R-nvim/R.nvim",
    lazy = false,
    opts = {
      -- Create a table with the options to be passed to setup()
      R_args = { "--quiet", "--no-save" },
      hook = {
        on_filetype = function()
          -- This function will be called at the FileType event
          -- of files supported by R.nvim. This is an
          -- opportunity to create mappings local to buffers.
          vim.keymap.set("n", "<Enter>", "<Plug>RDSendLine", { buffer = true })
          vim.keymap.set("v", "<Enter>", "<Plug>RSendSelection", { buffer = true })

          -- Increase the width of which-key to handle the longer r-nvim descriptions
          local wk = require("which-key")
          wk.setup({
            layout = {
              width = { min = 20, max = 100 }, -- min and max width of the columns
            },
          })

          -- Workaround from https://github.com/folke/which-key.nvim/issues/514#issuecomment-1987286901
          wk.register({
            ["<localleader>"] = {
              a = { name = "+(a)ll", ["🚫"] = "which_key_ignore" },
              b = { name = "+(b)etween marks", ["🚫"] = "which_key_ignore" },
              c = { name = "+(c)hunks", ["🚫"] = "which_key_ignore" },
              f = { name = "+(f)unctions", ["🚫"] = "which_key_ignore" },
              g = { name = "+(g)oto", ["🚫"] = "which_key_ignore" },
              k = { name = "+(k)nit", ["🚫"] = "which_key_ignore" },
              p = { name = "+(p)aragraph", ["🚫"] = "which_key_ignore" },
              q = { name = "+(q)uarto", ["🚫"] = "which_key_ignore" },
              r = { name = "+(r) general", ["🚫"] = "which_key_ignore" },
              s = { name = "+(s)plit or (s)end", ["🚫"] = "which_key_ignore" },
              t = { name = "+(t)erminal", ["🚫"] = "which_key_ignore" },
              v = { name = "+(v)iew", ["🚫"] = "which_key_ignore" },
            },
          })
        end,
      },
      -- pdfviewer = "open",
      pdfviewer = "", -- Yay my PR was merged!
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local rstt = {
        { "-", "#aaaaaa" }, -- 1: ftplugin/* sourced, but nclientserver not started yet.
        { "⏺︎", "#757755" }, -- 2: nclientserver started, but not ready yet.
        { "⏺︎", "       " }, -- 3: nclientserver is ready. (originally "#117711")
        { "⏺︎", "#ff8833" }, -- 4: nclientserver started the TCP server
        { "⏺︎", "#3388ff" }, -- 5: TCP server is ready
        { "⏺︎", "#ff8833" }, -- 6: R started, but nvimcom was not loaded yet.
        { "⏺︎", "#3388ff" }, -- 7: nvimcom is loaded.
      }
      local rstatus = function()
        if not vim.g.R_Nvim_status or vim.g.R_Nvim_status == 0 then
          -- No R file type (R, Quarto, Rmd, Rhelp) opened yet
          return ""
        end
        return rstt[vim.g.R_Nvim_status][1]
      end
      local rsttcolor = function()
        if not vim.g.R_Nvim_status or vim.g.R_Nvim_status == 0 then
          -- No R file type (R, Quarto, Rmd, Rhelp) opened yet
          return { fg = "#000000" }
        end
        return { fg = rstt[vim.g.R_Nvim_status][2] }
      end
      -- definition of rstatus
      opts.sections.lualine_y = vim.list_extend(opts.sections.lualine_y or {}, {
        { rstatus, color = rsttcolor },
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    dependencies = { "R-nvim/cmp-r" },
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, { name = "cmp_r" })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "markdown", "markdown_inline", "r", "rnoweb" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        r_language_server = {
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern("DESCRIPTION", "NAMESPACE", ".Rbuildignore")(fname)
              or require("lspconfig.util").find_git_ancestor(fname)
              or vim.loop.os_homedir()
          end,
        },
      },
    },
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "shunsambongi/neotest-testthat",
    },
    opts = {
      adapters = {
        ["neotest-testthat"] = {},
      },
    },
  },
}
