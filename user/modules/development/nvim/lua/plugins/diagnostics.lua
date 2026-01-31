return {
  "neovim/nvim-lspconfig",
  config = function()
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          return string.format("[%s] %s", diagnostic.source or "LSP", diagnostic.message)
        end,
      },
    })
  end,
}
