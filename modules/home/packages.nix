{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fuzzel
    wlogout
    wayprompt
    wl-clipboard
    brightnessctl
    pwvucontrol
    gnome-keyring
    libsecret
    gcr
    libnotify
    awww
    curl
    jq
    imagemagick
    mpv
    kdePackages.filelight
    nautilus
    gimp
    microsoft-edge
    zoom-us
    discord
    bun
    nodejs
    zip
    unzip
    gnupg
    nixpkgs-fmt
    statix
    godot
    blender
    btop
    grim
    slurp
    poppler-utils
    tesseract
    zathura
    lazygit
    just

    unityhub
    android-tools
    usbutils

    glow

    stremio-linux-shell
  ];
}
