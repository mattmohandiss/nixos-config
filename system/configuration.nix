{ config, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
    ./boot.nix
    ./networking.nix
    ./audio.nix
    ./power.nix
    ./security.nix
    ./services.nix
    ./users.nix
    ./wayland.nix
    ./gaming.nix
  ];

  environment.systemPackages = with pkgs; [
    # Media libraries for MiniDLNA
    ffmpeg
  ];
  
  # Note: gnome-keyring, libsecret, and nixfmt-rfc-style moved to user packages (mattm/packages.nix)

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.download-buffer-size = 52428800;

  # Time & locale
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Unfree packages allowed
  nixpkgs.config.allowUnfree = true;


  # Color Schemes
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    autoEnable = true;
  };

  system.stateVersion = "25.05";
}
