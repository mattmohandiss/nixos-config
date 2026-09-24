{ config
, inputs
, pkgs
, username
, homeDirectory
, ...
}:

let
  homeScripts = "${inputs.self}/scripts";
  askpassBin = "${pkgs.wayprompt}/bin/wayprompt-ssh-askpass";
  pinentryBin = "${pkgs.wayprompt}/bin/pinentry-wayprompt";
in
{
  programs.gpg.enable = true;

  #gtk.gtk4.theme = config.gtk.theme;

  home = {
    inherit username homeDirectory;
    stateVersion = "25.05";
    sessionVariables = {
      STYLIX_MONOSPACE_FONT = config.stylix.fonts.monospace.name;
      OPENCODE_ENABLE_EXA = "1";
      OPENCODE_EXPERIMENTAL = "true";
      OPENCODE_EXPERIMENTAL_LSP_TOOL = "true";
    };
    sessionPath = [
      "$HOME/.local/bin"
      homeScripts
      "$HOME/.bun/bin"
    ];
    file = {
      ".gnupg/gpg-agent.conf".text = ''
        pinentry-program ${pinentryBin}
      '';
      ".config/environment.d/askpass.conf".text = ''
        GIT_ASKPASS=${askpassBin}
        SSH_ASKPASS=${askpassBin}
      '';
    };
  };
}
