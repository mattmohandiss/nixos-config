{ config, pkgs, ... }:

{
  # Steam configuration following NixOS wiki best practices
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraArgs = "-system-composer";
    };
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
  };

  # GameMode configuration optimized for smooth, consistent gaming
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
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        amd_performance_level = "auto";
      };
      cpu = {
        park_cores = "no";
        pin_policy = "keep";
      };
      custom = {
        start = "${pkgs.writeShellScript "gamemode-start" ''
          # Reduce background process priority
          for pid in $(pgrep -f "firefox|chrome|code|discord"); do
            renice 10 $pid 2>/dev/null || true
          done
          
          # Set I/O scheduler for better gaming performance
          echo mq-deadline > /sys/block/nvme0n1/queue/scheduler 2>/dev/null || true
        ''}";
        end = "${pkgs.writeShellScript "gamemode-end" ''
          # Reset background process priority
          for pid in $(pgrep -f "firefox|chrome|code|discord"); do
            renice 0 $pid 2>/dev/null || true
          done
          
          # Reset I/O scheduler
          echo none > /sys/block/nvme0n1/queue/scheduler 2>/dev/null || true
        ''}";
      };
    };
  };

  # Thermal management optimized for smooth gaming (conservative approach)
  services.thermald = {
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
                  <Temperature>75000</Temperature>
                  <type>passive</type>
                  <CoolingDevice>
                    <index>1</index>
                    <type>intel_pstate</type>
                    <influence>50</influence>
                    <SamplingPeriod>1</SamplingPeriod>
                  </CoolingDevice>
                </TripPoint>
                <TripPoint>
                  <SensorType>x86_pkg_temp</SensorType>
                  <Temperature>80000</Temperature>
                  <type>passive</type>
                  <CoolingDevice>
                    <index>1</index>
                    <type>intel_pstate</type>
                    <influence>75</influence>
                    <SamplingPeriod>1</SamplingPeriod>
                  </CoolingDevice>
                </TripPoint>
                <TripPoint>
                  <SensorType>x86_pkg_temp</SensorType>
                  <Temperature>85000</Temperature>
                  <type>passive</type>
                  <CoolingDevice>
                    <index>1</index>
                    <type>intel_pstate</type>
                    <influence>100</influence>
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


  # Use native Intel P-State driver with power profiles (more stable than auto-cpufreq)
  services.auto-cpufreq.enable = false;
  
  # Enable power-profiles-daemon for better power management
  services.power-profiles-daemon.enable = true;

  # Hardware sensors for temperature monitoring
  hardware.sensor.iio.enable = true;

  # Gaming-related system packages
  environment.systemPackages = with pkgs; [
    gamemode # Optimize system performance for games
    mangohud # Performance overlay for games
    lm_sensors # Hardware monitoring utilities
    htop # Enhanced system monitor
    stress # System stress testing
    powertop # Power consumption analyzer
  ];

  # Add user to gamemode group for proper functionality
  users.users.mattm.extraGroups = [ "gamemode" ];

  # Kernel modules for hardware monitoring
  boot.kernelModules = [ "coretemp" "acpi_cpufreq" ];
}
