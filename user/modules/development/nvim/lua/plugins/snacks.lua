return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		picker = {
			layout = {
				layout = {
					backdrop = false,
					border = "rounded",
					box = "vertical",

                    -- size: use absolute integer dimensions to avoid any
                    -- fractional height/width calculations that Neovim rejects.
                    -- These are reasonable defaults you can tune to taste.
                    width = 80,
                    min_width = 60,
                    height = 30,
                    min_height = 10,

					-- center it
					--row = 0.2,
					--col = 0.2,

					title = "{title} {live} {flags}",
					title_pos = "center",

                    { win = "input", height = 1, border = "bottom" },
                    { win = "list", border = "none" },
                    { win = "preview", title = "{preview}", height = 15, min_height = 8, border = "top" },
				},
			},

			sources = {
				explorer = {
					jump = {
						close = true, -- close explorer after opening a file
					},
				},
			},
		},

		explorer = {
			replace_netrw = true,
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
	},
}
