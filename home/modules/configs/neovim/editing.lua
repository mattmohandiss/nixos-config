-- Text editing enhancements

-- Treesitter setup
require('nvim-treesitter.configs').setup({
  highlight = { enable = true },
  indent = { enable = true },
})

-- Quality of life plugins
require('Comment').setup({})
require('nvim-autopairs').setup({})
