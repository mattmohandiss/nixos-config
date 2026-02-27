{ lib
, config
, pkgs
, inputs
, ...
}:

{
  programs.gpg.enable = true;

  # Home Manager core configuration
  home = {
    username = "mattm";
    homeDirectory = "/home/mattm";
    stateVersion = "25.05";
    sessionPath = [
      "/etc/nixos/scripts"
      "$HOME/.bun/bin"
    ];
    file = {
      ".gnupg/gpg-agent.conf" = {
        text = ''
          pinentry-program /etc/nixos/scripts/zenity-pinentry
        '';
      };
      ".config/environment.d/askpass.conf" = {
        text = ''
          GIT_ASKPASS=/etc/nixos/scripts/zenity-askpass
          SSH_ASKPASS=/etc/nixos/scripts/zenity-askpass
          export GIT_ASKPASS SSH_ASKPASS
        '';
      };
    };
  };
}
