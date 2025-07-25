{ config, pkgs, ... }:

{
  # MiniDLNA Media Server
  services.minidlna = {
    enable = true;
    settings = {
      friendly_name = "Matt's Laptop";
      media_dir = [
        "V,/srv/media"
      ];
      port = 8200;
      presentation_url = "http://192.168.68.0:8200/";
      inotify = "yes";
      enable_tivo = "no";
      strict_dlna = "no";  # Better compatibility with various devices
      force_sort_criteria = "+dc:title";
    };
  };

  # Create media directory with proper permissions
  systemd.tmpfiles.rules = [
    "d /srv/media 0775 mattm users -"
  ];
}
