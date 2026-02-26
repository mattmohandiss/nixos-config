{ config
, pkgs
, inputs
, ...
}:

{
  imports = [ inputs.niri.nixosModules.niri ];

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "mattm";
      };
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  xdg.portal.enable = true;
  xdg.portal.config.common.default = "*";

  environment.systemPackages = with pkgs; [ xwayland-satellite ];

  services.xserver.xkb = {
    layout = "dk";
    variant = "";
  };
}
