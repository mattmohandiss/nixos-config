{ pkgs, ... }:

{
  hardware = {
    graphics.enable32Bit = true;
    steam-hardware.enable = true;
  };

  programs.steam = {
    enable = true;
    package = pkgs.steam.override { extraArgs = "-system-composer"; };
  };
}
