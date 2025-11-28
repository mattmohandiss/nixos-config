{ config, pkgs, ... }:

{

  # System-wide theming with Stylix
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

  services.iptsd.enable = true;

  # Firmware update service
  services.fwupd.enable = true;

  # MiniDLNA Media Server
  services.minidlna = {
    enable = true;
    settings = {
      friendly_name = "Matt's Laptop";
      media_dir = [ "V,/srv/media" ];
      port = 8200;
      presentation_url = "http://192.168.68.0:8200/";
      inotify = "yes";
      enable_tivo = "no";
      strict_dlna = "no"; # Better compatibility with various devices
      force_sort_criteria = "+dc:title";
    };
  };

  # Enhanced logging and crash analysis services
  services.journald = {
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

  # hardware.rasdaemon.enable = true;

  # # Give rasdaemon narrow access to tracefs and wait for instances
  # # to appear. Preserve kernel protection flags and add only the
  # # minimal ambient capability to help with trace operations.
  # systemd.services.rasdaemon = {
  #   serviceConfig = {
  #     ReadWritePaths = "/sys/kernel/tracing /sys/kernel/debug/tracing/instances";
  #     ExecStartPre = "/bin/sh -c 'until [ -d /sys/kernel/tracing/instances ] || [ -d /sys/kernel/debug/tracing/instances ]; do sleep 0.1; done'";
  #   };
  #   after = [ "systemd-modules-load.service" ];
  # };

  # System coredump collection
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

  # System monitoring and hardware health
  environment.systemPackages = with pkgs; [
    # Hardware monitoring
    lm_sensors
    smartmontools
    acpi
    powertop
    iotop

    # System analysis tools
    strace
    ltrace
    gdb
    binutils

    # Performance monitoring
    perf-tools
    sysstat

    # Thermal monitoring
    stress-ng

    # Memory testing
    memtester
  ];

  # Create directories with proper permissions
  systemd.tmpfiles.rules = [
    "d /srv/media 0775 mattm users -"
    "d /var/crash-reports 0755 root root -"
    "d /var/log/crash-analysis 0755 root root -"
  ];

  # Enable hardware sensors
  hardware.sensor.iio.enable = true;
}
