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
      # NixOS system configuration (system-level only)
      nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          nixos-hardware.nixosModules.microsoft-surface-pro-intel
          stylix.nixosModules.stylix
          ./nixos/configuration.nix
          {
            nixpkgs.config.allowUnfree = true;
            nixpkgs.overlays = [
              nur.overlays.default
              niri.overlays.niri
            ];
          }
        ];
        specialArgs = {
          inherit inputs;
        };
      };

      # Standalone Home Manager configuration (user-level only)
      homeConfigurations.mattm = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            nur.overlays.default
            niri.overlays.niri
          ];
        };
        modules = [
          ./home/default.nix
          niri.homeModules.niri
          zen-browser.homeModules.twilight
        ];
        extraSpecialArgs = {
          inherit inputs;
        };
      };
    };
}
