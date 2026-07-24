{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wlogout
    wayprompt
    wl-clipboard
    brightnessctl
    grim
    slurp
    pwvucontrol
    libsecret
    gcr
    libnotify
    awww
    kdePackages.filelight
    nautilus
    microsoft-edge
    zoom-us
    discord
    teams-for-linux
    blueman
    usbutils
  ];
}
