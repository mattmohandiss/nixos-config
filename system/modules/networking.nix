{ ... }:

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
  };

  environment.etc."ssl/certs/eduroam.pem".source = ../../eduroam.pem;
}
