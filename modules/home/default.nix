{ inputs, username, fullName, homeDirectory, ... }:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (final: prev: {
      lean-ctx = prev.callPackage ../../pkgs/lean-ctx.nix { };

      wayprompt = prev.wayprompt.overrideAttrs (_:
        let
          zigWaylandHash = "1220687c8c47a48ba285d26a05600f8700d37fc637e223ced3aa8324f3650bf52242";
          patchedZigWayland = final.runCommand "zig-wayland-patched" { } ''
            tmp=$TMPDIR/zig-wayland
            mkdir -p $tmp
            tar -C ${prev.wayprompt.deps}/${zigWaylandHash} -cf - . | tar -C $tmp -xf -
              chmod -R u+rwX $tmp
              sed -i 's/_err: Error/_err: {[type]}.Error/' $tmp/src/scanner.zig
              mkdir -p $out
              cp -r --no-preserve=all $tmp/. $out/
          '';
          patchedDeps = final.runCommand "wayprompt-zig-packages" { } ''
            mkdir -p $out
            cp -r ${prev.wayprompt.deps}/. $out/
            rm -rf $out/${zigWaylandHash}
            cp -r ${patchedZigWayland} $out/${zigWaylandHash}
          '';
        in
        {
          deps = patchedDeps;
        });
    })
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
      ./apps/panel.nix
      ./apps/desktop.nix
      ./apps/browser/defaults.nix
      ./apps/browser/firefox.nix
      ./apps/browser/zen.nix
      ./dev/default.nix
      ./shell.nix
      ./packages
    ];
  };
}
