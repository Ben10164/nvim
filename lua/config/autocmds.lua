-- Autocmds are automatically loaded on the VeryLazy event

vim.api.nvim_create_autocmd("FileType", {
  desc = "python autocmds",
  group = vim.api.nvim_create_augroup("py_mapping", { clear = true }),
  pattern = "python",
  callback = function()
    vim.keymap.set({ "n" }, "<C-r>", "", {
      desc = "Run current .py file in terminal",
      callback = function()
        -- Get file name in the current buffer
        local file_name = vim.api.nvim_buf_get_name(0)

        local py_cmd = vim.api.nvim_replace_termcodes('ipython "' .. file_name .. '"<cr>', true, false, true)

        local term_exists_in_tabpage = false
        local term_win = -1
        for _, window in ipairs(vim.api.nvim_list_wins()) do
          local win_bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(window))
          if win_bufname:match("zsh") then
            term_exists_in_tabpage = true
            term_win = window
          end
        end

        if term_exists_in_tabpage == false and term_win == -1 then
          local term_height = math.floor(vim.api.nvim_win_get_height(0) * 0.3) -- Terminal height

          vim.cmd(":below " .. term_height .. "split | term")

          term_win = vim.api.nvim_get_current_win()

          vim.api.nvim_feedkeys(py_cmd, "t", false)
        else
          -- Reuse the existing terminal buffer
          vim.api.nvim_set_current_win(term_win)
          vim.api.nvim_feedkeys(py_cmd, "t", false)
        end
      end,
    })
  end,
})
