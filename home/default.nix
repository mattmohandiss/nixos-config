{
  config,
  pkgs,
  inputs,
  ...
}:

{
  # Import all user-level configurations
  imports = [
    ./modules/packages.nix
    ./modules/services.nix
    ./modules/xdg.nix
    ./modules/mcp/configuration.nix
    ./modules/desktop/niri.nix
    ./modules/desktop/waybar.nix
    ./modules/desktop/wallpaper.nix
    ./modules/applications/firefox.nix
    ./modules/applications/vscode.nix
    ./modules/applications/kitty.nix
    ./modules/applications/media.nix
    ./modules/applications/zen-browser.nix
    ./modules/applications/neovim.nix
    # Note: styling.nix excluded - handled at system level
  ];

  # Home Manager core configuration
  home.username = "mattm";
  home.homeDirectory = "/home/mattm";
  home.stateVersion = "25.05";

  # Session path
  home.sessionPath = [
    "/etc/nixos/home/modules/scripts"
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
      branch.autosetupmerge = "always";
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
