{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    fuzzel
    zenity
    wl-clipboard
    brightnessctl
    pwvucontrol
    gnome-keyring
    libsecret
    gcr
    nerd-fonts.fira-code
    mako
    libnotify
    swww
    curl
    jq
    imagemagick
    aria2 # Multi-protocol download utility with torrent support
    mpv # Media player
    kdePackages.filelight
    nautilus
    gimp
    microsoft-edge
    love
    zoom-us
    discord

    # Bun development tools
    bun # Fast JavaScript runtime and package manager
    nodejs

    zip
    unzip

    # GPG for Git commit signing
    gnupg
    pinentry-gtk2

    fwupd

    godot
    blender

    bat
    btop
    eza

    grim
    slurp
    tesseract # OCR engine for text extraction

    # Directory environment management
    direnv

    # On Screen Keyboard
    wvkbd

    # Rotation
    wlr-randr

    zathura
    lazygit
  ];
}
