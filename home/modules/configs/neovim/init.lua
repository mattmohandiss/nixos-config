-- Main Neovim configuration entry point

-- Load configuration modules in order
dofile('/etc/nixos/mattm/configs/neovim/options.lua')     -- Basic vim settings first
dofile('/etc/nixos/mattm/configs/neovim/autocmds.lua')    -- Autocommands
dofile('/etc/nixos/mattm/configs/neovim/editing.lua')     -- Text editing (treesitter) - load before keymaps that depend on telescope
dofile('/etc/nixos/mattm/configs/neovim/search.lua')      -- Search functionality (telescope, wilder)
dofile('/etc/nixos/mattm/configs/neovim/completion.lua')  -- Completion setup
dofile('/etc/nixos/mattm/configs/neovim/lsp.lua')         -- Language servers
dofile('/etc/nixos/mattm/configs/neovim/ui.lua')          -- UI components
dofile('/etc/nixos/mattm/configs/neovim/keymaps.lua')     -- Keybindings (load after plugins are configured)
