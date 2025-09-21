-- Main Neovim configuration entry point

-- Load configuration modules in order
dofile('/etc/nixos/home/modules/configs/neovim/options.lua')     -- Basic vim settings first
dofile('/etc/nixos/home/modules/configs/neovim/autocmds.lua')    -- Autocommands
dofile('/etc/nixos/home/modules/configs/neovim/editing.lua')     -- Text editing (treesitter) - load before keymaps that depend on telescope
dofile('/etc/nixos/home/modules/configs/neovim/search.lua')      -- Search functionality (telescope, wilder)
dofile('/etc/nixos/home/modules/configs/neovim/completion.lua')  -- Completion setup
dofile('/etc/nixos/home/modules/configs/neovim/lsp.lua')         -- Language servers
dofile('/etc/nixos/home/modules/configs/neovim/ui.lua')          -- UI components
dofile('/etc/nixos/home/modules/configs/neovim/keymaps.lua')     -- Keybindings (load after plugins are configured)
