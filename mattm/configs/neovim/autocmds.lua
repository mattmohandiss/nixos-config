-- Autocommands

-- Format on save
vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    pcall(vim.lsp.buf.format, { timeout_ms = 1500 })
  end
})
