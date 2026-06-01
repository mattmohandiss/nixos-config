{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ffmpeg
    nil
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

  services.journald.extraConfig = ''
    Storage=persistent
    MaxRetentionSec=30d
    MaxFileSec=1week
    Compress=yes
    SplitMode=uid
    RateLimitInterval=30s
    RateLimitBurst=10000
  '';

  systemd.coredump = {
    enable = true;
    settings.Coredump = {
      Storage = "external";
      Compress = "yes";
      ProcessSizeMax = "2G";
      ExternalSizeMax = "2G";
      MaxUse = "5G";
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/crash-reports 0755 root root -"
    "d /var/log/crash-analysis 0755 root root -"
  ];

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
}
