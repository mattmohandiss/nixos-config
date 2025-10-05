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
  
  # Git configuration
  programs.git = {
    enable = true;
    userName = "Matt Mohandiss";
    userEmail = "mattmohandiss@gmail.com";
    
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.default = "simple";
      push.autoSetupRemote = true;
      remote.pushDefault = "origin";
      core.editor = "nvim";
      core.autocrlf = "input";
      # GPG signing configuration
      commit.gpgsign = true;
      user.signingkey = "381948BAC468E711";
    };
    
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      visual = "!gitk";
    };
  };

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    pinentry = {
      package = pkgs.pinentry-gtk2;
    };
    enableSshSupport = true;
  };
}
