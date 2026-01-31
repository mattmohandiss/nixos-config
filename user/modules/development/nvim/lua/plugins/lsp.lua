return {
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        keymaps = {
          -- remap Mason's "apply language filter" to <leader>f to avoid <C-F> conflicts
          apply_language_filter = "<leader>f",
        },
      },
    },
  },
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
