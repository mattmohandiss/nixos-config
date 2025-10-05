{ config, pkgs, ... }:

{
  # VSCode/VSCodium configuration
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    profiles.default = {
      # Editor settings
      userSettings = {
        # File settings
        "files.autoSave" = "afterDelay";
        "files.autoSaveDelay" = 1000;
        
        # Nix language server
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "nix.serverSettings" = {
          "nixd" = {
            # Evaluation settings - tells nixd how to understand your system
            "eval" = {
              "target" = {
                "args" = [ "--flake" "/etc/nixos#nixos" ];
                "installable" = "";
              };
            };
            
            # Formatting configuration
            "formatting" = {
              "command" = [ "nixfmt" ];
            };
            
            # Options documentation
            "options" = {
              "nixos" = {
                "expr" = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.nixos.options";
              };
              "home-manager" = {
                "expr" = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.nixos.options.home-manager.users.type.getSubOptions []";
              };
            };
            
            # Nixpkgs for package completions
            "nixpkgs" = {
              "expr" = "import (builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs { }";
            };
            
            # Diagnostic control
            "diagnostic" = {
              "suppress" = [
                "sema-extra-with"
              ];
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
