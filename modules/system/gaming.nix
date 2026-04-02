{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    package = pkgs.steam.override { extraArgs = "-system-composer"; };
  };
}
