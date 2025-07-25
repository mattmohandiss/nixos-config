{ config, pkgs, ... }:

{
  # XDG desktop entry for magnet link handling
  xdg.desktopEntries = {
    aria2c-magnet = {
      name = "aria2c Magnet Handler";
      exec = "/etc/nixos/mattm/scripts/magnet-download %u";
      mimeType = [ "x-scheme-handler/magnet" ];
      noDisplay = true;
    };
  };
}
