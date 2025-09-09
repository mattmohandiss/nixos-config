-- Basic vim settings
vim.o.termguicolors = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.updatetime = 200
vim.o.signcolumn = "yes"

-- Tab settings - display tabs as 2 spaces wide but keep them as tab characters
vim.o.tabstop = 2        -- Number of spaces that a tab character displays as
vim.o.shiftwidth = 2     -- Number of spaces to use for each step of indentation
vim.o.expandtab = false  -- Keep tabs as tab characters (don't convert to spaces)
vim.o.smartindent = true -- Smart autoindenting for new lines
vim.o.autoindent = true  -- Copy indent from current line when starting new line
