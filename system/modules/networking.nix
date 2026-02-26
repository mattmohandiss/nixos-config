{ config, pkgs, ... }:

{
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;

    firewall = {
      allowedTCPPorts = [ 8200 ];
      allowedUDPPorts = [ 1900 ];
      allowedTCPPortRanges = [
        {
          from = 6881;
          to = 6999;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 6881;
          to = 6999;
        }
      ];
    };

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
          identity = "your.full.username@domain";
          "anonymous-identity" = "anonymous@ku.dk";
          "phase2-auth" = "mschapv2";
          "ca-cert" = "/etc/ssl/certs/eduroam.pem";
          "altsubject-matches" = "DNS:radius.ku.dk";
        };
      };
    };
  };

  environment.etc."ssl/certs/eduroam.pem".source = ../../eduroam.pem;
}
