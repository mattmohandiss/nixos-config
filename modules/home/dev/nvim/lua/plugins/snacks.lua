return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		scroll = {
		},

		picker = {
			layout = {
				layout = {
					backdrop = false,
					border = "rounded",
					box = "vertical",

					width = 80,
					min_width = 60,
					height = 30,
					min_height = 10,

					title = "{title} {live} {flags}",
					title_pos = "center",

					{ win = "input", height = 1, border = "bottom" },
					{ win = "list", border = "none" },
					{ win = "preview", title = "{preview}", height = 15, min_height = 8, border = "top" },
				},
			},

			sources = {
				explorer = {
					jump = { close = true },
					hidden = true,
				},
			},
		},

		explorer = {
			replace_netrw = true,
			trash = true,
		},
	},

	keys = {
		{
			"<C-Space>",
			function()
				Snacks.explorer()
			end,
			desc = "Explorer (centered)",
		},
		{
			"<C-g>",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep",
		},
		{
			"<C-r>",
			function()
				Snacks.picker.lsp_references()
			end,
			desc = "LSP References",
		},
		{
			"<leader>j",
			function()
				require("pickers.just").pick()
			end,
			desc = "Just: pick recipe",
		},
		{
			"<leader>df",
			function()
				require("dap").run({
					type = "python",
					request = "attach",
					name = "Attach: FreeCAD (debugpy :5678)",
					connect = { host = "127.0.0.1", port = 5678 },
					justMyCode = false,
				})
			end,
			desc = "DAP: attach FreeCAD",
		},
	},
}
