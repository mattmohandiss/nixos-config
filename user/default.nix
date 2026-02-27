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
        ./modules/home.nix
        ./modules/applications/niri.nix
        ./modules/applications/desktop.nix
        ./modules/development/default.nix
        ./modules/shell/default.nix
        ./modules/browsers/firefox.nix
        ./modules/browsers/stylix.nix
        ./modules/browsers/zen-browser.nix
        ./modules/packages.nix
      ];
    };
  };
}
