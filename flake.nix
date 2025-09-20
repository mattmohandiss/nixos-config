{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri.url = "github:sodiboo/niri-flake";
    
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      home-manager,
      stylix,
      nur,
      niri,
      zen-browser,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          nixos-hardware.nixosModules.microsoft-surface-pro-intel
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          ./system/configuration.nix
          {
            nixpkgs.config.allowUnfree = true;
            nixpkgs.overlays = [
              nur.overlays.default
              niri.overlays.niri
            ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.mattm = import ./mattm/configuration.nix;
            home-manager.sharedModules = [
              niri.homeModules.niri
              niri.homeModules.stylix
              zen-browser.homeModules.twilight
            ];
            home-manager.extraSpecialArgs = {
              inherit inputs;
            };
          }
        ];
        specialArgs = {
          inherit inputs;
        };
      };
    };
}
