{ config
, pkgs
, inputs
, ...
}: {
  imports = [
    ./modules/audio.nix
    ./modules/boot.nix
    ./modules/gaming.nix
    ./modules/hardware-configuration.nix
    ./modules/networking.nix
    ./modules/niri.nix
    ./modules/power.nix
    ./modules/security.nix
    ./modules/services.nix
    ./modules/users.nix
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  environment.systemPackages = with pkgs; [
    ffmpeg
    pulseaudio
    pavucontrol
    home-manager
    git
    # pawbar provided via flake input
    (inputs.pawbar.packages.${system}.default)
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      download-buffer-size = 52428800;
      auto-optimise-store = true;
    };
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  programs.nix-ld.enable = true;

  boot.loader.systemd-boot.configurationLimit = 10;

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

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
  ];
}
