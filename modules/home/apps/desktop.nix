{ pkgs, inputs, ... }:

let
  wallpaperScript = "${inputs.self}/scripts/wallpaper";
in
{
  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;
      ignore-timeout = true;
      anchor = "top-right";
      margin = "10";
      border-radius = 5;
      actions = true;
    };
  };

  systemd.user.services.awww = {
    Unit = {
      Description = "Awww wallpaper daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.awww}/bin/awww-daemon";
      ExecStartPost = "${wallpaperScript} load";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
      "text/plain" = "nvim.desktop";
      "application/pdf" = "firefox.desktop";
      "image/jpeg" = "firefox.desktop";
      "image/png" = "firefox.desktop";
      "video/mp4" = "mpv.desktop";
      "audio/mpeg" = "mpv.desktop";
      "inode/directory" = "kitty-open.desktop";
      "application/zip" = "org.gnome.Nautilus.desktop";
    };
  };
}
