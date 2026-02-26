{ pkgs, ... }: {
  stylix.targets.neovim.enable = false;
  
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;

    extraPackages = with pkgs; [
      tree-sitter
      gcc
      fzf
      ripgrep
      fd
      curl
      luarocks
      cargo
      just
      cmake
    ];
  };
}
