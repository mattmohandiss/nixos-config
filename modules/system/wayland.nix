{ config, pkgs, ... }:

{
  # Wayland + Niri
  programs.niri = {
    enable = true;
    package = pkgs.niri-stable;
  };

  # Login manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "mattm";
      };
    };
  };

  # Environment for Wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    # Note: XDG_CURRENT_DESKTOP is set in mattm/desktop/niri.nix
  };

  # Wayland portals
  xdg.portal.enable = true;
  xdg.portal.config.common.default = "*";  # Fix portal warning

  # XWayland support for X11 applications like Steam
  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];

  # Keyboard layout
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
}
