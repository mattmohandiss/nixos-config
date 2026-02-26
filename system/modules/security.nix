{ config, pkgs, ... }:

{
  services = {
    dbus = {
      enable = true;
      packages = [ pkgs.nautilus ];
    };
    gnome.gnome-keyring.enable = true;
  };
  programs.dconf.enable = true;

  security = {
    polkit.enable = true;
    pam.services.login.enableGnomeKeyring = true;
    pam.services.greetd.enableGnomeKeyring = true;
  };
}
