{ config, pkgs, ... }:

{
  # XDG MIME type associations
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Web browser associations - Firefox as default
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";

      # Associate magnet links with aria2c handler
      "x-scheme-handler/magnet" = "aria2c-magnet.desktop";

      # Text and Code
      "text/plain" = "nvim.desktop";

      # PDF and Images
      "application/pdf" = "firefox.desktop";
      "image/jpeg" = "firefox.desktop";
      "image/png" = "firefox.desktop";

      # Media
      "video/mp4" = "mpv.desktop";
      "audio/mpeg" = "mpv.desktop";

      # System
      "inode/directory" = "kitty-open.desktop";
      "application/zip" = "org.gnome.Nautilus.desktop";
    };
  };
}
