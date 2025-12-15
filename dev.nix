let
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-25.11.tar.gz";
    sha256 = "sha256-mSD5Ob7a+T2RNjvPvOA1dkJHGVrNVl8ZOrAwBjKBDQo=";
  };
  system = "x86_64-linux";
  pkgs = import nixpkgs { inherit system; };
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    just
    nixpkgs-fmt
    statix
    deadnix
    nix-tree
    nixd
  ];

  shellHook = ''
    echo "🔧 NixOS Dev Shell loaded"
    echo "   Run 'just describe' for available commands"
  '';
}
