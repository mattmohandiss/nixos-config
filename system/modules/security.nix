{ config, pkgs, ... }:

{
  # D-Bus and keyring services
  services.dbus.enable = true;
  services.dbus.packages = [ pkgs.nautilus ]; # For niri screen sharing
  programs.dconf.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # Security and authentication
  security = {
    polkit.enable = true;
    pam.services.login.enableGnomeKeyring = true;
    pam.services.greetd.enableGnomeKeyring = true;
  };
}
