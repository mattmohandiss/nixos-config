{
  config,
  pkgs,
  inputs,
  ...
}:

{
  # Import all modular configurations
  imports = [
    ./packages.nix
    ./services.nix
    ./xdg.nix
    ./mcp/configuration.nix
    ./desktop/niri.nix
    ./desktop/waybar.nix
    ./desktop/styling.nix
    ./desktop/wallpaper.nix
    ./applications/firefox.nix
    ./applications/vscode.nix
    ./applications/kitty.nix
    ./applications/media.nix
    ./applications/zen-browser.nix
    ./applications/neovim.nix
  ];

  # Home Manager core configuration
  home.username = "mattm";
  home.homeDirectory = "/home/mattm";
  home.stateVersion = "25.05";

  # Note: Session environment variables are configured in mattm/desktop/niri.nix

  home.sessionPath = [
    "/etc/nixos/mattm/scripts"
    "$HOME/.bun/bin"
  ];

  # Shell configuration
  programs.zsh = {
    enable = true;
    initContent = ''
      eval "$(direnv hook zsh)"
    '';
  };

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;

    enableSshSupport = true;
  };
}
