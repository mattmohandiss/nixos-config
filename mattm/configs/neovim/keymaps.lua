-- Keybindings

-- Telescope keybinds
local tb = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', tb.find_files, {desc = 'Find files'})
vim.keymap.set('n', '<leader>fg', tb.live_grep, {desc = 'Live grep'})
vim.keymap.set('n', '<leader>fb', tb.buffers, {desc = 'Buffers'})
vim.keymap.set('n', '<leader>fh', tb.help_tags, {desc = 'Help'})
vim.keymap.set('n', '<A-Space>', tb.find_files, {desc = 'Find files (Alt+Space)'})

-- Buffer navigation keybindings (normal mode only)
vim.keymap.set('n', '<A-Right>', ':BufferLineCycleNext<CR>', { desc = 'Next buffer', silent = true })
vim.keymap.set('n', '<A-Left>', ':BufferLineCyclePrev<CR>', { desc = 'Previous buffer', silent = true })
vim.keymap.set('n', '<A-S-Left>', ':BufferLineMovePrev<CR>', { desc = 'Move buffer left', silent = true })
vim.keymap.set('n', '<A-S-Right>', ':BufferLineMoveNext<CR>', { desc = 'Move buffer right', silent = true })
vim.keymap.set('n', '<A-q>', ':bdelete<CR>', { desc = 'Close current buffer', silent = true })

-- Copy/paste with Alt+C and Alt+V
vim.keymap.set('v', '<A-c>', '"+y', { desc = 'Copy to clipboard', silent = true })
vim.keymap.set('n', '<A-c>', '"+yy', { desc = 'Copy line to clipboard', silent = true })
vim.keymap.set('n', '<A-v>', '"+p', { desc = 'Paste from clipboard', silent = true })
vim.keymap.set('i', '<A-v>', '<C-r>+', { desc = 'Paste from clipboard in insert mode', silent = true })
