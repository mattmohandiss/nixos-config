return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")
			ts.setup() -- optional, only needed for non-default opts

			-- Install parsers (optional)
			ts.install({ "lua", "python", "javascript", "typescript", "nix" })

			-- Enable TS highlight + folds per filetype
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					pcall(vim.treesitter.start)
					vim.cmd("setlocal foldmethod=expr")
					vim.cmd("setlocal foldexpr=v:lua.vim.treesitter.foldexpr()")
					vim.cmd("setlocal foldlevel=99")
				end,
			})
		end,
		keys = {
			{ "<C-p>", "za", desc = "Toggle fold under cursor" },
			-- {
			-- 	"<C-P>",
			-- 	function()
			-- 		if vim.fn.foldclosed(1) ~= -1 then
			-- 			vim.cmd("normal! zR")
			-- 		else
			-- 			vim.cmd("normal! zM")
			-- 		end
			-- 	end,
			-- 	desc = "Toggle all folds",
			-- },
		},
	},
}

