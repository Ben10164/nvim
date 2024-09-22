return {
  {
    "R-nvim/R.nvim",
    ft = { "R", "Rmd" },
    optional = true,
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
          wk.add({
            buffer = true,
            { "<localleader>a", group = "all" },
            { "<localleader>b", group = "between marks" },
            { "<localleader>c", group = "chunks" },
            { "<localleader>f", group = "functions" },
            { "<localleader>g", group = "goto" },
            { "<localleader>i", group = "install" },
            { "<localleader>k", group = "knit" },
            { "<localleader>p", group = "paragraph" },
            { "<localleader>q", group = "quarto" },
            { "<localleader>r", group = "r general" },
            { "<localleader>s", group = "split or send" },
            { "<localleader>t", group = "terminal" },
            { "<localleader>v", group = "view" },
          })
        end,
      },
      pdfviewer = "",
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
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
}
