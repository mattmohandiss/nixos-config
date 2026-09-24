{ pkgs, ... }:

{
  home.packages = with pkgs; [
    curl
    jq
    imagemagick
    bun
    nodejs
    nixd
    zip
    unzip
    nixpkgs-fmt
    statix
    sops
    age
    lean-ctx
    btop
    lazygit
    just
    glow
    gh
    playwright-mcp
    ollama
  ];
}
