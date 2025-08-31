{ config, pkgs, ... }:

{
  # VSCode/VSCodium configuration
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    profiles.default = {
      # Editor settings
      userSettings = {
        "files.autoSave" = "afterDelay";
        "files.autoSaveDelay" = 1000;
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "nix.serverSettings" = {
          "nixd" = {
            "formatting" = {
              "command" = [ "nixfmt" ];
            };
            "options" = {
              "nixos" = {
                "expr" = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.nixos.options";
              };
            };
          };
        };
        
        # Direnv integration settings
        "direnv.restart.automatic" = true;
        "direnv.status.showOnStatusBar" = true;
        
      };

      # Extensions
      extensions =
        with pkgs.vscode-extensions;
        [
          christian-kohler.path-intellisense
          ms-python.python
          ms-python.vscode-pylance
          mkhl.direnv
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "claude-dev";
            publisher = "saoudrizwan";
            version = "3.20.1";
            hash = "sha256-2IX6EdzNpJapgVSwQ9hyby7CdURI5uaQJpGh4pcEuaQ=";
          }
          {
            name = "nix-ide";
            publisher = "jnoortheen";
            version = "0.4.22";
            sha256 = "1ib8czlqhqq1rz6jrazfd9z3gfqdwqazxdvwmsyp765m0vf78xcg";
          }
        ];
    };
  };

  # VSCodium configuration for password store integration
  xdg.configFile."VSCodium/argv.json".text = builtins.toJSON {
    "password-store" = "gnome-libsecret";
  };
}
