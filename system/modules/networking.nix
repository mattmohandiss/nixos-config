{ config, pkgs, ... }:

{
  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Firewall configuration
  networking.firewall = {
    allowedTCPPorts = [ 8200 ]; # MiniDLNA HTTP streaming port
    allowedUDPPorts = [ 1900 ]; # SSDP discovery port for DLNA
    # BitTorrent port ranges for aria2c
    allowedTCPPortRanges = [
      {
        from = 6881;
        to = 6999;
      }
      # BitTorrent TCP port range
    ];
    allowedUDPPortRanges = [
      {
        from = 6881;
        to = 6999;
      }
      # BitTorrent UDP port range (includes DHT)
    ];
  };
}
