lint:
  statix check .

format:
  nixpkgs-fmt .

switch:
  sudo nixos-rebuild switch

build:
  sudo nixos-rebuild build --flake .

update:
  nix flake update

clean:
  sudo nix-collect-garbage -d

repair:
  sudo nix-store --verify --check-contents --repair
