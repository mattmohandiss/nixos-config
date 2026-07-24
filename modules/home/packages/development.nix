{ pkgs, ... }:

{
  home.packages = with pkgs; [
    curl
    jq
    imagemagick
    bun
    nodejs
    zip
    unzip
    nixpkgs-fmt
    statix
    lean-ctx
    btop
    lazygit
    just
    glow
    gh
  ];
}
