-- Autocommands

-- Format on save
vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    pcall(vim.lsp.buf.format, { timeout_ms = 1500 })
  end
})

-- Open Telescope when starting Neovim on a directory
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    local arg = vim.fn.argv(0)
    if arg and vim.fn.isdirectory(arg) == 1 then
      -- Close the directory buffer (netrw)
      vim.cmd('bdelete')
      -- Delay opening Telescope to ensure it's fully loaded and keymaps are ready
      vim.defer_fn(function()
        require('telescope.builtin').find_files()
      end, 10) -- 10ms delay should be sufficient
    end
  end
})
