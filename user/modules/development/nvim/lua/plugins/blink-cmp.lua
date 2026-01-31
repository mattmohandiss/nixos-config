return {
	"Saghen/blink.cmp",
	dependencies = "rafamadriz/friendly-snippets",
	version = "*",
	opts = {
		keymap = {
			preset = "none",
			["<Down>"] = { "select_next", "fallback" },
			["<Up>"] = { "select_prev", "fallback" },
			["<CR>"] = { "accept", "fallback" },
			["<C-Space>"] = {
				function(cmp)
					-- If signature is open, hide it
					if require("blink.cmp.signature.window").win:is_open() then
						return cmp.hide_signature()
					end

					-- If completion menu is open, hide it
					if cmp.is_visible() then
						return cmp.hide()
					end

					-- Get the character BEFORE the cursor (fixed off-by-one)
					local col = vim.api.nvim_win_get_cursor(0)[2]
					local line = vim.api.nvim_get_current_line()
					local char_before = col > 0 and line:sub(col, col) or ""

					-- If we're after a trigger character like '(', show signature help
					if char_before == "(" then
						return cmp.show_signature()
					end

					-- Otherwise show normal completion
					return nil -- Continue to next command
				end,
				"show",
				"show_documentation",
				"hide_documentation",
			},
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
		completion = {
			list = {
				selection = {
					auto_insert = false, -- Don't auto-insert when selecting
				},
			},
			ghost_text = {
				enabled = true,
				show_with_selection = true, -- Show ghost text when item is selected
				show_with_menu = true, -- Show ghost text when menu is open
			},
			menu = {
				winhighlight = "Normal:None",
				draw = {
					columns = { { "kind_icon" }, { "label" }, { "kind" }, { "label_description" } },
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 500,
			},
		},
		signature = {
			enabled = true,
			trigger = {
				enabled = true, -- Required
				show_on_accept = true, -- Required
				show_on_accept_on_trigger_character = true, -- Required (default)
			},
		},
	},
}
