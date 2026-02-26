{ inputs, ... }:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    inputs.nur.overlays.default
    inputs.niri.overlays.niri
  ];
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    backupFileExtension = ".bak";
    users.mattm = {
      imports = [
        inputs.zen-browser.homeModules.twilight
        ./modules/dotfiles.nix
        ./modules/home.nix
        ./modules/applications/niri.nix
        ./modules/applications/notifications.nix
        ./modules/applications/wallpaper.nix
        ./modules/development/git.nix
        ./modules/development/neovim.nix
        ./modules/development/vscode.nix
        ./modules/secrets
        ./modules/shell/zsh.nix
        ./modules/shell/kitty.nix
        ./modules/shell/aliases.nix
        ./modules/shell/direnv.nix
        ./modules/web/firefox.nix
        ./modules/web/stylix.nix
        ./modules/web/zen-browser.nix
        ./modules/packages.nix
        ./modules/xdg.nix
      ];
    };
  };
}
