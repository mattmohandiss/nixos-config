{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
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

    # Nix development tools
    nixd # Nix language server
    nixfmt-rfc-style # Modern Nix formatter (RFC 166 style)

    # Python development tools
    uv # Modern Python package manager
    python3 # Base Python interpreter
    python3Packages.python-lsp-server # Language server for VS Code

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
  ];
}
