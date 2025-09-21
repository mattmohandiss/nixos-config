{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    parts.url   = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ self, nixpkgs, parts, ... }:
    parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];

      perSystem = { pkgs, system, lib, ... }:
      let
        names = builtins.attrNames (builtins.readDir ./pkgs);
        call = n: pkgs.callPackage (./pkgs + "/${n}") {};
      in {
        _module.args.pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };

        # Expose every pkg automatically
        packages = lib.genAttrs names call // { default = call "gemini-cli"; };

        # Optional: expose apps automatically for CLIs with bin=<name>
        apps = lib.genAttrs names (n: {
          type = "app";
          program = "${(call n)}/bin/${n}";
        });
      };

      # Optional: auto host discovery
      flake.nixosConfigurations =
        let
          hostNames = builtins.attrNames (builtins.readDir ./hosts);
          mkHost = name: nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [ (./hosts + "/${name}/default.nix") ];
          };
        in builtins.listToAttrs (map (h: { name = h; value = mkHost h; }) hostNames);
    };
}
