{ config, pkgs, ... }:

{
  programs.steam = {
    enable = true;
    package = pkgs.steam.override { extraArgs = "-system-composer"; };
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
}
