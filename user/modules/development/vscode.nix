{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    profiles.default = {

      #userSettings = /etc/nixos/user/modules/development/vscode.json;

      extensions =
        with pkgs.vscode-extensions;
        [
          christian-kohler.path-intellisense
          ms-python.python
          ms-python.vscode-pylance
          mkhl.direnv
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [

        ];
    };
  };

  xdg.configFile."VSCodium/argv.json".text = builtins.toJSON {
    "password-store" = "gnome-libsecret";
  };


}
