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

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = inputs.nixpkgs.legacyPackages.${system};

      makeDevShell = { name, extra-packages ? [] }:
        pkgs.mkShell {
          name = "${name}-dev-shell";
          packages = extra-packages;
        };

    in
    {
      nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
          inputs.stylix.nixosModules.stylix
          inputs.home-manager.nixosModules.home-manager
          {
            programs.direnv.enable = true;
            programs.direnv.nix-direnv.enable = true;
            nixpkgs.config.allowUnfree = true;
            nixpkgs.overlays = [
              inputs.nur.overlays.default
              inputs.niri.overlays.niri
            ];
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.mattm = {
                imports = [
                  inputs.niri.homeModules.niri
                  inputs.zen-browser.homeModules.twilight
                  inputs.nixvim.homeManagerModules.nixvim
                  ./home.nix
                ];
              };
            };
          }
        ];
        specialArgs = { inherit inputs; };
      };
      devShells."${system}" = let
        shells = ["default" "nix" "python" "typescript" "haskell" "lua" "go"];
      in inputs.nixpkgs.lib.genAttrs shells (name:
        let config = import ./dev-shells/${name}.nix { inherit pkgs; };
        in makeDevShell config
      );
    };
}
