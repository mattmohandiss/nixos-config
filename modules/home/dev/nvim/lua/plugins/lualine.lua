return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			section_separators = { left = "", right = "" },
			component_separators = { left = "", right = "" },
			--always_show_tabline = "true",
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch", "diff", "diagnostics" },
			lualine_c = { "filename" },
			lualine_x = { "encoding", "fileformat", "filetype" },
			lualine_y = { "location", "progress" },
			lualine_z = { "lsp_status" },
		},
		tabline = {
			lualine_a = { "buffers" },
		},
	},
}
