{ pkgs, ... }:

{
  # Swww wallpaper daemon service
  systemd.user.services.swww = {
    Unit = {
      Description = "Swww wallpaper daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.swww}/bin/swww-daemon";
      # Try current.jpg first, fallback to any wallpaper in the directory
      ExecStartPost = "${pkgs.bash}/bin/bash -c 'sleep 2 && ${pkgs.swww}/bin/swww img /etc/nixos/home/modules/wallpapers/current.jpg'";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
