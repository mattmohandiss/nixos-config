{
  config,
  pkgs,
  inputs,
  ...
}:

{
  # Import all user-level configurations
  imports = [ ./modules ];

  # Home Manager core configuration
  home.username = "mattm";
  home.homeDirectory = "/home/mattm";
  home.stateVersion = "25.05";

  # Session path
  home.sessionPath = [
    "/etc/nixos/scripts"
    "$HOME/.bun/bin"
  ];

  # Git configuration
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Matt Mohandiss";
        email = "mattmohandiss@gmail.com";
      };
      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
        unstage = "reset HEAD --";
        last = "log -1 HEAD";
        visual = "!gitk";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      push.default = "simple";
      branch.autosetupmerge = "always";
      core.editor = "nvim";
      core.autocrlf = "input";
      credential.helper = "libsecret";
      commit.gpgsign = true;
      user.signingkey = "381948BAC468E711";
    };
  };

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    extraConfig = ''
      pinentry-program /etc/nixos/scripts/fuzzel-pinentry
    '';
    enableSshSupport = true;
  };
}
