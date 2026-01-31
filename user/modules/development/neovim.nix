# Converted to standalone Lua config in ~/.config/nvim/init.lua
# Neovim is now configured via Lua instead of Nix
{ pkgs, ... }: {
  stylix.targets.neovim.enable = false;
  
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped; # Ensure latest version >= 0.11.2 with LuaJIT

    # Dependencies for lazy nvim and plugins
    extraPackages = with pkgs; [
      # For nvim-treesitter
      tree-sitter
      gcc

      # For fzf-lua
      fzf
      ripgrep
      fd

      # For blink.cmp
      curl

      # Optional: lazygit
      lazygit
			
			# LSP tools
      luarocks
			cargo

			just

			cmake
    ];
  };
}
