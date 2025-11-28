{
  config,
  pkgs,
  inputs,
  ...
}:

{
  # Home Manager core configuration
  home.username = "mattm";
  home.homeDirectory = "/home/mattm";
  home.stateVersion = "25.05";
  
  # Session path
  home.sessionPath = [
    "/etc/nixos/scripts"
    "$HOME/.bun/bin"
  ];

  # Ensure GPG uses zenity pinentry and GUI askpass are set
  home.file = {
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

}
