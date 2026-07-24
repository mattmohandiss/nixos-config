{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ffmpeg
    nil
    lm_sensors
    smartmontools
    acpi
    powertop
    strace
    gdb
    binutils
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
}
