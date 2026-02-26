{ config, pkgs, ... }:

{
  programs.steam = {
    enable = true;
    package = pkgs.steam.override { extraArgs = "-system-composer"; };
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
  };

  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 5;
        ioprio = 1;
        inhibit_screensaver = 1;
        softrealtime = "on";
        reaper_freq = 3;
      };
      cpu = {
        park_cores = "no";
        pin_policy = "keep";
      };
      custom = {
        start = "${pkgs.writeShellScript "gamemode-start" ''
          for pid in $(pgrep -f "firefox|chrome|code|discord"); do
            renice 10 $pid 2>/dev/null || true
          done

          echo mq-deadline > /sys/block/nvme0n1/queue/scheduler 2>/dev/null || true

          echo performance > /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor 2>/dev/null || true

          for hwmon in /sys/class/hwmon/hwmon*; do
            if [[ -f "$hwmon/pwm1" ]]; then
              echo 200 > "$hwmon/pwm1" 2>/dev/null || true
            fi
          done

          echo 1 > /sys/devices/system/cpu/cpu*/cpuidle/state*/disable 2>/dev/null || true
        ''}";
        end = "${pkgs.writeShellScript "gamemode-end" ''
          for pid in $(pgrep -f "firefox|chrome|code|discord"); do
            renice 0 $pid 2>/dev/null || true
          done

          echo none > /sys/block/nvme0n1/queue/scheduler 2>/dev/null || true

          echo powersave > /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor 2>/dev/null || true

          for hwmon in /sys/class/hwmon/hwmon*; do
            if [[ -f "$hwmon/pwm1_enable" ]]; then
              echo 2 > "$hwmon/pwm1_enable" 2>/dev/null || true
            fi
          done

          echo 0 > /sys/devices/system/cpu/cpu*/cpuidle/state*/disable 2>/dev/null || true
        ''}";
      };
    };
  };

  services = {
    thermald = {
      enable = true;
      debug = false;
      configFile = pkgs.writeText "thermal-conf.xml" ''
        <?xml version="1.0"?>
        <ThermalConfiguration>
          <Platform>
            <Name>Surface Pro 8</Name>
            <ProductName>*</ProductName>
            <Preference>PERFORMANCE</Preference>
            <ThermalZones>
              <ThermalZone>
                <Type>x86_pkg_temp</Type>
                <TripPoints>
                  <TripPoint>
                    <SensorType>x86_pkg_temp</SensorType>
                    <Temperature>88000</Temperature>
                    <type>passive</type>
                    <CoolingDevice>
                      <index>1</index>
                      <type>intel_pstate</type>
                      <influence>25</influence>
                      <SamplingPeriod>1</SamplingPeriod>
                    </CoolingDevice>
                    <CoolingDevice>
                      <index>2</index>
                      <type>Fan</type>
                      <influence>50</influence>
                      <SamplingPeriod>1</SamplingPeriod>
                    </CoolingDevice>
                  </TripPoint>
                  <TripPoint>
                    <SensorType>x86_pkg_temp</SensorType>
                    <Temperature>92000</Temperature>
                    <type>passive</type>
                    <CoolingDevice>
                      <index>1</index>
                      <type>intel_pstate</type>
                      <influence>50</influence>
                      <SamplingPeriod>1</SamplingPeriod>
                    </CoolingDevice>
                    <CoolingDevice>
                      <index>2</index>
                      <type>Fan</type>
                      <influence>75</influence>
                      <SamplingPeriod>1</SamplingPeriod>
                    </CoolingDevice>
                    <CoolingDevice>
                      <index>3</index>
                      <type>intel_powerclamp</type>
                      <influence>25</influence>
                      <SamplingPeriod>2</SamplingPeriod>
                    </CoolingDevice>
                  </TripPoint>
                  <TripPoint>
                    <SensorType>x86_pkg_temp</SensorType>
                    <Temperature>96000</Temperature>
                    <type>passive</type>
                    <CoolingDevice>
                      <index>1</index>
                      <type>intel_pstate</type>
                      <influence>75</influence>
                      <SamplingPeriod>1</SamplingPeriod>
                    </CoolingDevice>
                    <CoolingDevice>
                      <index>2</index>
                      <type>Fan</type>
                      <influence>100</influence>
                      <SamplingPeriod>1</SamplingPeriod>
                    </CoolingDevice>
                    <CoolingDevice>
                      <index>3</index>
                      <type>intel_powerclamp</type>
                      <influence>50</influence>
                      <SamplingPeriod>1</SamplingPeriod>
                    </CoolingDevice>
                  </TripPoint>
                  <TripPoint>
                    <SensorType>x86_pkg_temp</SensorType>
                    <Temperature>99000</Temperature>
                    <type>passive</type>
                    <CoolingDevice>
                      <index>1</index>
                      <type>intel_pstate</type>
                      <influence>100</influence>
                      <SamplingPeriod>1</SamplingPeriod>
                    </CoolingDevice>
                    <CoolingDevice>
                      <index>2</index>
                      <type>Fan</type>
                      <influence>100</influence>
                      <SamplingPeriod>1</SamplingPeriod>
                    </CoolingDevice>
                    <CoolingDevice>
                      <index>3</index>
                      <type>intel_powerclamp</type>
                      <influence>75</influence>
                      <SamplingPeriod>1</SamplingPeriod>
                    </CoolingDevice>
                  </TripPoint>
                </TripPoints>
              </ThermalZone>
            </ThermalZones>
          </Platform>
        </ThermalConfiguration>
      '';
    };
    power-profiles-daemon.enable = true;
    udev.extraRules = ''
      KERNEL=="card*", SUBSYSTEM=="drm", TAG+="uaccess"
    '';
  };

  environment.systemPackages = with pkgs; [
    gamemode
    mangohud
    htop
    stress
    intel-gpu-tools
    linuxPackages.turbostat
    s-tui
    linuxPackages.cpupower
  ];

  users.users.mattm.extraGroups = [
    "gamemode"
    "video"
  ];

  boot.kernelModules = [
    "coretemp"
    "acpi_cpufreq"
    "intel_powerclamp"
    "x86_pkg_temp_thermal"
  ];
}
