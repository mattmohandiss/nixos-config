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

                    -- size: use percentages for responsiveness but provide
                    -- integer minimums so snacks doesn't compute a fractional
                    -- window height that Neovim rejects.
                    width = 0.8,
                    min_width = 60,
                    height = 0.8,
                    min_height = 10,

					-- center it
					--row = 0.2,
					--col = 0.2,

					title = "{title} {live} {flags}",
					title_pos = "center",

                    { win = "input", height = 1, border = "bottom" },
                    { win = "list", border = "none" },
                    { win = "preview", title = "{preview}", height = 0.45, min_height = 8, border = "top" },
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
