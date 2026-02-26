{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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
      inputs."nixpkgs-stable".follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # enable git submodules for flakes located in git repositories
    self = {
      submodules = true;
    };

    pawbar = {
      url = "git+https://github.com/nekorg/pawbar.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      inherit (nixpkgs) lib;
    in
    {
      nixosConfigurations.nixos = lib.nixosSystem {
        inherit system;

        modules =
          [
            ./system
            ./user
            inputs.stylix.nixosModules.stylix
          ];

        specialArgs = { inherit inputs; };
      };
    };
}
