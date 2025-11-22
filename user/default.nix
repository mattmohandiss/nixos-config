{ inputs, ... }:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    inputs.nur.overlays.default
    inputs.niri.overlays.niri
  ];
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.mattm = {
      imports = [
        inputs.zen-browser.homeModules.twilight
        inputs.nixvim.homeModules.nixvim
        ./home.nix
        ./modules
      ];
    };
  };
}
