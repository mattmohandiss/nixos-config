{ config, pkgs, ... }:

{
  # D-Bus and keyring services
  services = {
    dbus = {
      enable = true;
      packages = [ pkgs.nautilus ]; # For niri screen sharing
    };
    gnome.gnome-keyring.enable = true;
  };
  programs.dconf.enable = true;

  # Security and authentication
  security = {
    polkit.enable = true;
    pam.services.login.enableGnomeKeyring = true;
    pam.services.greetd.enableGnomeKeyring = true;
  };
}
