_:

{
  imports = [
    ./hardware-configuration.nix
    ./surface.nix
    ../../modules/system
    ../../modules/home
  ];

  _module.args = {
    username = "mattm";
    fullName = "Matt Mohandiss";
    homeDirectory = "/home/mattm";
  };

  networking.hostName = "surface";

  system.stateVersion = "25.05";
}
