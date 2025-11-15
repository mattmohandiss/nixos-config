{
  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # stylix = {
    #   url = "github:nix-community/stylix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs =
    { self, ... }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./system
          ./user
          # inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
          # inputs.stylix.nixosModules.stylix
        ];
        specialArgs = { inherit inputs; };
      };
    };
}
