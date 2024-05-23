return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        markdownlint = {
          args = { "--disable", "MD009", "MD011", "MD012", "MD013", "--" },
        },
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      -- vim.print(opts.mapping)
      opts.mapping["<CR>"] = nil
      -- opts.completion = {autocomplete = false}
      -- Loop through the sources table to find and remove the buffer source
      for i, source in ipairs(opts.sources) do
        if source.name == "buffer" then
          table.remove(opts.sources, i)
        end
      end
    end,
  },
}
