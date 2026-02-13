return {
	-- DAP core
	{
		"mfussenegger/nvim-dap",
		keys = {
			{ "<F5>",  function() require("dap").continue() end, desc = "DAP continue" },
			{ "<F10>", function() require("dap").step_over() end, desc = "DAP step over" },
			{ "<F11>", function() require("dap").step_into() end, desc = "DAP step into" },
			{ "<F12>", function() require("dap").step_out() end, desc = "DAP step out" },
			{ "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP breakpoint" },
			{ "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "DAP conditional bp" },
			{ "<leader>dr", function() require("dap").repl.open() end, desc = "DAP REPL" },
			{ "<leader>dl", function() require("dap").run_last() end, desc = "DAP run last" },
			{ "<leader>dd", function() require("pickers.dap").pick() end, desc = "DAP pick config" },
		},
		config = function()
			local dap = require("dap")

			-- Keep only what you *must* customize:
			-- FreeCAD uses debugpy.listen(("127.0.0.1", 5678)) inside FreeCAD
			dap.configurations.python = dap.configurations.python or {}
			table.insert(dap.configurations.python, {
				name = "Attach: FreeCAD (debugpy :5678)",
				type = "python",
				request = "attach",
				connect = { host = "127.0.0.1", port = 5678 },
				justMyCode = false,
			})
		end,
	},

	-- DAP UI
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		keys = {
			{ "<leader>du", function() require("dapui").toggle() end, desc = "DAP UI toggle" },
		},
		config = function()
			local dap, dapui = require("dap"), require("dapui")
			dapui.setup()

			dap.listeners.after.event_initialized["dapui"] = function() dapui.open() end
			dap.listeners.before.event_terminated["dapui"] = function() dapui.close() end
			dap.listeners.before.event_exited["dapui"] = function() dapui.close() end
		end,
	},

	-- Mason integration for DAP adapters (optional but recommended)
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
		opts = {
			automatic_installation = true,
			ensure_installed = {
				"python", -- debugpy adapter
				-- add more later: "codelldb", "js", etc.
			},
		},
	},
}

