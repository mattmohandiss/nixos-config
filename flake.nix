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
      nixvim,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      makeDevShell =
        {
          name,
          nixvim-lang-attrs ? { },
          extra-packages,
        }:
        let
          base-config = (import ./home/modules/applications/neovim.nix).programs.nixvim;
          final-config = pkgs.lib.recursiveUpdate base-config nixvim-lang-attrs;
          cleaned-config = builtins.removeAttrs final-config [
            "enable"
            "viAlias"
            "vimAlias"
          ];
          nixvim' = nixvim.legacyPackages.${system}.makeNixvim cleaned-config;
        in
        pkgs.mkShell {
          name = "${name}-dev-shell";
          packages = [ nixvim' ] ++ extra-packages;
        };

    in
    {
      nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          nixos-hardware.nixosModules.microsoft-surface-pro-intel
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          ./nixos/configuration.nix
          {
            programs.direnv.enable = true;
            programs.direnv.nix-direnv.enable = true;
            nixpkgs.config.allowUnfree = true;
            nixpkgs.overlays = [
              nur.overlays.default
              niri.overlays.niri
            ];
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.mattm = import ./home/default.nix;
              extraSpecialArgs = { inherit inputs; };
              sharedModules = [
                niri.homeModules.niri
                zen-browser.homeModules.twilight
                nixvim.homeManagerModules.nixvim
              ];
            };
          }
        ];
        specialArgs = { inherit inputs; };
      };
      devShells."${system}" = {
        default = makeDevShell ((import ./dev-shells/default.nix) { inherit pkgs; });
        nix = makeDevShell ((import ./dev-shells/nix.nix) { inherit pkgs; });
        python = makeDevShell ((import ./dev-shells/python.nix) { inherit pkgs; });
        typescript = makeDevShell ((import ./dev-shells/typescript.nix) { inherit pkgs; });
        haskell = makeDevShell ((import ./dev-shells/haskell.nix) { inherit pkgs; });
        lua = makeDevShell ((import ./dev-shells/lua.nix) { inherit pkgs; });
        go = makeDevShell ((import ./dev-shells/go.nix) { inherit pkgs; });
      };
    };
}
