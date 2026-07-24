{ config, lib, pkgs, ... }:

{
  stylix.targets.neovim.enable = false;

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    withRuby = true;
    withPython3 = true;

    extraPackages = with pkgs; [
      tree-sitter
      gcc
      fzf
      ripgrep
      fd
      luarocks
      cmake
    ];
  };

  xdg.configFile."nvim/init.lua".enable = lib.mkForce false;

  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "/etc/nixos/modules/home/dev/nvim";
}
