return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      --labels = "123456789",
			modes = {
        search = {
          enabled = true,
        },
      },
			label = {
				rainbow = { enabled = false, shade = 2 }
			},
			highlight = {
				matches = false
			}
    },
    keys = {
			{ "j",  function() require("flash").jump() end, mode = { "n", "x", "o" }, desc = "Flash jump" },
      { "J",  function() require("flash").treesitter() end, mode = { "n", "x", "o" }, desc = "Flash TS" },
			-- { "r",  function() require("flash").remote() end, mode = "o", desc = "Flash remote" },
      -- { "R",  function() require("flash").treesitter_search() end, mode = { "n", "o" }, desc = "Flash TS search" },
      -- { "<c-s>", function() require("flash").toggle() end, mode = "c", desc = "Toggle Flash search" },
    },
  },
}
