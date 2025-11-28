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

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;

       importDirRecursive = dir:
        builtins.filter
          (path: lib.hasSuffix ".nix" path)
          (lib.filesystem.listFilesRecursive dir);
    in
    {
      nixosConfigurations.nixos = lib.nixosSystem {
        inherit system;

        modules =
          [ inputs.stylix.nixosModules.stylix ]
          ++ importDirRecursive ./system
          ++ [ ./user/default.nix ];

        specialArgs = { inherit inputs; };
      };
    };
}

