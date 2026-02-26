{ config, pkgs, ... }:

{
  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font";
      };
    };
  };

  qt = {
    platformTheme = "qt5ct";
  };

  services = {
    iptsd.enable = true;
    fwupd.enable = true;
    minidlna = {
      enable = true;
      settings = {
        friendly_name = "Matt's Laptop";
        media_dir = [ "V,/srv/media" ];
        port = 8200;
        presentation_url = "http://192.168.68.0:8200/";
        inotify = "yes";
        enable_tivo = "no";
        strict_dlna = "no";
        force_sort_criteria = "+dc:title";
      };
    };
    journald = {
      extraConfig = ''
        Storage=persistent
        MaxRetentionSec=30d
        MaxFileSec=1week
        Compress=yes
        SplitMode=uid
        RateLimitInterval=30s
        RateLimitBurst=10000
      '';
    };
  };

  systemd.coredump = {
    enable = true;
    extraConfig = ''
      Storage=external
      Compress=yes
      ProcessSizeMax=2G
      ExternalSizeMax=2G
      MaxUse=5G
    '';
  };

  environment.systemPackages = with pkgs; [
    lm_sensors
    smartmontools
    acpi
    powertop
    iotop
    strace
    ltrace
    gdb
    binutils
    perf-tools
    sysstat
    stress-ng
    memtester
    surface-control
  ];

  systemd.tmpfiles.rules = [
    "d /srv/media 0775 mattm users -"
    "d /var/crash-reports 0755 root root -"
    "d /var/log/crash-analysis 0755 root root -"
  ];

  hardware.sensor.iio.enable = true;
}
