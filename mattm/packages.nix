{ pkgs, ... }:

{
  home.packages = with pkgs; [
    waybar
    fuzzel
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

    # Nix development tools
    nixd # Nix language server
    nixfmt-rfc-style # Modern Nix formatter (RFC 166 style)

    # Bun development tools
    bun # Fast JavaScript runtime and package manager
    
    # GPG for Git commit signing
    gnupg
    pinentry-gtk2

    godot
    blender

    bat
    btop
    eza

    grim
    slurp
    
    # Directory environment management
    direnv
  ];
}
