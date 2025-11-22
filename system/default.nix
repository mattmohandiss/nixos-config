{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./modules
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  environment.systemPackages = with pkgs; [
    # Media libraries for MiniDLNA
    ffmpeg
    # Home Manager CLI tool
    home-manager
    # Modern CLI tools for zsh configuration
    ripgrep
    fd
    neovim
    git
  ];

  # Note: gnome-keyring, libsecret, and nixfmt-rfc-style moved to user packages (mattm/packages.nix)

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.download-buffer-size = 52428800;

  # NIX_PATH for better nixd flake support
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Automatic store optimization
  nix.settings.auto-optimise-store = true;

  programs.nix-ld.enable = true;

  # Limit number of generations to keep
  boot.loader.systemd-boot.configurationLimit = 10;

  # Time & locale
  # time.timeZone = "America/New_York";
  services.automatic-timezoned.enable = true;
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

  # Fonts for proper icon display in terminal
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
  ];

  system.stateVersion = "25.05";
}
