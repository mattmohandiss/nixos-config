{ pkgs, ... }:

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
    };
  };
}
