{ config, pkgs, ... }:

{
  stylix.targets.neovim.enable = false;

  programs = {
    git = {
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
        core = {
          editor = "nvim";
          autocrlf = "input";
          askpass = "/etc/nixos/scripts/zenity-askpass";
        };
        credential.helper = "libsecret";
        commit.gpgsign = true;
        user.signingkey = "381948BAC468E711";
      };
    };

    neovim = {
      enable = true;
      package = pkgs.neovim-unwrapped;

      extraPackages = with pkgs; [
        tree-sitter
        gcc
        fzf
        ripgrep
        fd
        curl
        luarocks
        cargo
        just
        cmake
      ];
    };

    vscode = {
      enable = true;
      package = pkgs.vscodium;

      profiles.default = {
        extensions =
          with pkgs.vscode-extensions;
          [
            christian-kohler.path-intellisense
            ms-python.python
            ms-python.vscode-pylance
            mkhl.direnv
          ]
          ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [];
      };
    };
  };

  home.file.".config/nvim" = {
    target = ".config/nvim";
    source = config.lib.file.mkOutOfStoreSymlink
      "/etc/nixos/user/modules/development/nvim";
  };

  xdg.configFile."VSCodium/argv.json".text = builtins.toJSON {
    "password-store" = "gnome-libsecret";
  };
}
