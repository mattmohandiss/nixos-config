lint:
  statix check .

format:
  nixpkgs-fmt .

switch:
  sudo nixos-rebuild switch --flake 'path:/etc/nixos#surface'

build:
  sudo nixos-rebuild build --flake 'path:/etc/nixos#surface'

alias upgrade := update
update:
  nix flake update

clean:
  sudo nix-collect-garbage -d

repair:
  sudo nix-store --verify --check-contents --repair
