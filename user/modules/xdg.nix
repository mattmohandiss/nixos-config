{ config, pkgs, ... }:

{
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
