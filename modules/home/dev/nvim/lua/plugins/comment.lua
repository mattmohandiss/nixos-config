return {
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    keys = {
      { "gcc",  function() require("Comment.api").toggle.linewise.current() end, mode = "n", desc = "Toggle line comment" },
      { "gc",   function() require("Comment.api").toggle.linewise(vim.fn.visualmode()) end, mode = "v", desc = "Toggle comment" },
    },
    config = function()
      require("Comment").setup({})
    end,
  },
}
