{ pkgs, ... }:

{
  # XDG MIME type associations
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Associate magnet links with aria2c handler
      "x-scheme-handler/magnet" = "aria2c-magnet.desktop";
    };
  };
}
