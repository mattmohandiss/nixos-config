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
    # Use a local override that fetches pawbar with submodules so vaxis is present
    (let
      pawSrc = pkgs.fetchgit {
        url = "https://github.com/nekorg/pawbar.git";
        rev = "8a4359c04599da753cc311c2d97e89e0677a4111";
        fetchSubmodules = true;
        # pinned sha256 computed from a previous fetch
        sha256 = "sha256-7a9Ry2bWeERjOVSgYXFmrHRc+PpvMJ3ED1SWNpifI9Y=";
      };
    in pkgs.buildGoModule {
      pname = "pawbar-local";
      version = "0-unstable-2025-08-31";
      src = pawSrc;
      # repo layout exposes the CLI under `cmd/`, not `cmd/pawbar`
      subPackages = [ "cmd" ];
      vendorHash = "sha256-DUjfFrmpjSUWDicncTXvL1mnnPqEEKGyz6PTLEnGD7E=";
      buildInputs = with pkgs; [ udev librsvg cairo ];
      nativeBuildInputs = with pkgs; [ pkg-config ];
    })
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
