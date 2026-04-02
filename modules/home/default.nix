{ inputs, username, fullName, homeDirectory, ... }:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    inputs.nur.overlays.default
    inputs.niri.overlays.niri
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs username fullName homeDirectory;
    };
    backupFileExtension = ".bak";
    users.${username}.imports = [
      inputs.zen-browser.homeModules.twilight
      ./core.nix
      ./apps/niri.nix
      ./apps/desktop.nix
      ./apps/browser-common.nix
      ./apps/firefox.nix
      ./apps/zen.nix
      ./dev/default.nix
      ./shell.nix
      ./packages.nix
    ];
  };
}
