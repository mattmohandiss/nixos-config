-- LSP setup

local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = {'vim'} }
    }
  }
})
lspconfig.pyright.setup({ capabilities = capabilities })
lspconfig.ts_ls.setup({ capabilities = capabilities })
