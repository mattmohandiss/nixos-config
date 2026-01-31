return {
  { "mason-org/mason.nvim", opts = {} },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
			automatic_enable = true,
			ui = {
				keymaps = {
					apply_language_filter = "<leader>f",
				}
			}
		},
    dependencies = { "neovim/nvim-lspconfig" },
  },
}

