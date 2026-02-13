{ config, pkgs, ... }:

{
  # Networking
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;

    # Firewall configuration
    firewall = {
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

    # Declarative NetworkManager profile for eduroam (PEAP/MSCHAPv2).
    # The secret (password) is intentionally omitted so NetworkManager will
    # prompt and store it in GNOME Keyring (recommended).
    networkmanager.ensureProfiles.profiles = {
      eduroam = {
        connection = {
          id = "eduroam";
          type = "wifi";
          permissions = "";
        };

        wifi = {
          ssid = "eduroam";
          mode = "infrastructure";
          security = "802-1x";
        };

        "802-1x" = {
          eap = "peap";
          identity = "your.full.username@domain"; # replace with your real identity
          "anonymous-identity" = "anonymous@ku.dk";
          "phase2-auth" = "mschapv2";
          "ca-cert" = "/etc/ssl/certs/eduroam.pem";
          "altsubject-matches" = "DNS:radius.ku.dk";
        };
      };
    };
  };

  # Place eduroam CA cert into /etc/ssl/certs so NetworkManager can use it
  # Source path is repository-relative to this module file
  environment.etc."ssl/certs/eduroam.pem".source = ../eduroam.pem;
}
