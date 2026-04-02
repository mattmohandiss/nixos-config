{ lib
, config
, pkgs
, inputs
, username
, homeDirectory
, ...
}:

let
  homeScripts = "${inputs.self}/scripts";
in
{
  programs.gpg.enable = true;

  gtk.gtk4.theme = config.gtk.theme;

  # Home Manager core configuration
  home = {
    inherit username homeDirectory;
    stateVersion = "25.05";
    sessionPath = [
      homeScripts
      "$HOME/.bun/bin"
    ];
    file = {
      ".gnupg/gpg-agent.conf" = {
        text = ''
          pinentry-program ${homeScripts}/zenity-pinentry
        '';
      };
      ".config/environment.d/askpass.conf" = {
        text = ''
          GIT_ASKPASS=${homeScripts}/zenity-askpass
          SSH_ASKPASS=${homeScripts}/zenity-askpass
          export GIT_ASKPASS SSH_ASKPASS
        '';
      };
    };
  };
}
