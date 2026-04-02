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
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cascadefox = {
      url = "github:cascadefox/cascade";
      flake = false;
    };

    pawbar = {
      url = "git+https://github.com/nekorg/pawbar.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      username = "mattm";
      fullName = "Matt Mohandiss";
      homeDirectory = "/home/${username}";
      inherit (nixpkgs) lib;
    in
    {
      nixosConfigurations.nixos = lib.nixosSystem {
        inherit system;

        modules = [
          inputs.stylix.nixosModules.stylix
          ./system
          ./user
        ];

        specialArgs = {
          inherit inputs username fullName homeDirectory;
        };
      };
    };
}
