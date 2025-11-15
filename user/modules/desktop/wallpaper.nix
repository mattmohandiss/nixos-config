{ pkgs, ... }:

{
  # Swww wallpaper daemon service with unified wallpaper management
  systemd.user.services.swww = {
    Unit = {
      Description = "Swww wallpaper daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.swww}/bin/swww-daemon";
      ExecStartPost = "${pkgs.bash}/bin/bash -c '/etc/nixos/scripts/wallpaper load'";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
