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
          
          # Thermal optimizations for gaming
          # Set performance governor for maximum clocks
          echo performance > /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor 2>/dev/null || true
          
          # Increase fan speed if controllable (Surface Pro 8)
          for hwmon in /sys/class/hwmon/hwmon*; do
            if [[ -f "$hwmon/pwm1" ]]; then
              echo 200 > "$hwmon/pwm1" 2>/dev/null || true
            fi
          done
          
          # Disable CPU idle states for consistent performance
          echo 1 > /sys/devices/system/cpu/cpu*/cpuidle/state*/disable 2>/dev/null || true
        ''}";
        end = "${pkgs.writeShellScript "gamemode-end" ''
          # Reset background process priority
          for pid in $(pgrep -f "firefox|chrome|code|discord"); do
            renice 0 $pid 2>/dev/null || true
          done
          
          # Reset I/O scheduler
          echo none > /sys/block/nvme0n1/queue/scheduler 2>/dev/null || true
          
          # Reset thermal optimizations
          # Return to powersave governor for better thermal management
          echo powersave > /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor 2>/dev/null || true
          
          # Return fan to automatic control
          for hwmon in /sys/class/hwmon/hwmon*; do
            if [[ -f "$hwmon/pwm1_enable" ]]; then
              echo 2 > "$hwmon/pwm1_enable" 2>/dev/null || true
            fi
          done
          
          # Re-enable CPU idle states for power efficiency
          echo 0 > /sys/devices/system/cpu/cpu*/cpuidle/state*/disable 2>/dev/null || true
        ''}";
      };
    };
  };

  # Thermal management optimized for gaming performance (Surface Pro 8 appropriate)
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


  # Use native Intel P-State driver with power profiles (more stable than auto-cpufreq)
  services.auto-cpufreq.enable = false;
  
  # Enable power-profiles-daemon for better power management
  services.power-profiles-daemon.enable = true;

  # Fix GameMode GPU access permissions
  services.udev.extraRules = ''
    KERNEL=="card*", SUBSYSTEM=="drm", TAG+="uaccess"
  '';

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
    intel-gpu-tools # Intel GPU monitoring and control
    linuxPackages.turbostat # CPU frequency/power monitoring
    s-tui # Terminal-based CPU stress testing and monitoring
    linuxPackages.cpupower # CPU frequency utilities
  ];

  # Add user to gamemode group for proper functionality
  users.users.mattm.extraGroups = [ "gamemode" ];

  # Kernel modules for comprehensive thermal management
  boot.kernelModules = [ 
    "coretemp"                # CPU temperature monitoring
    "acpi_cpufreq"           # ACPI CPU frequency scaling
    "intel_powerclamp"       # Power clamping for thermal control
    "intel_rapl"             # Intel RAPL power limiting
    "x86_pkg_temp_thermal"   # Package temperature thermal driver
  ];
}
