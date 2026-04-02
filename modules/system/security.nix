{ pkgs, ... }:

{
  services.dbus = {
    enable = true;
    packages = [ pkgs.nautilus ];
  };

  services.gnome.gnome-keyring.enable = true;

  programs = {
    dconf.enable = true;
    nix-ld.enable = true;
    zsh.enable = true;
    git.config.global.submodule.recurse = true;
  };

  security = {
    polkit.enable = true;
    pam.services.login.enableGnomeKeyring = true;
    pam.services.greetd.enableGnomeKeyring = true;
  };
}
