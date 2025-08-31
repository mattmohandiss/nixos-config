{ config, pkgs, ... }:

{
  # Enable all firmware for Surface Pro 8 support
  hardware.enableAllFirmware = true;

  # Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Surface-specific kernel modules for hardware support
  boot.kernelModules = [
    "surface_aggregator"
    "surface_aggregator_registry" 
    "surface_aggregator_hub"
    "surface_battery"
    "surface_charger"
    "surface_platform_profile"
    "surface_hotplug"
    "8250_dw"  # Surface UART support
    "coretemp" # CPU temperature monitoring
    "acpi_cpufreq" # ACPI CPU frequency scaling
  ];

  # Surface Pro 8 stability optimizations + touchpad fixes
  boot.kernelParams = [
    "intel_idle.max_cstate=1"      # Prevent deep CPU sleep states that cause hangs
    "processor.max_cstate=1"       # Limit processor C-states for stability
    "i915.enable_psr=0"           # Disable panel self refresh (causes graphics hangs)
    "i915.enable_fbc=0"           # Disable framebuffer compression (can cause issues)
    "intel_iommu=igfx_off"        # Disable IOMMU for Intel graphics (reduces crashes)
    
    # Thermal management optimizations
    "intel_pstate=active"         # Use Intel P-State driver for better thermal control
    "thermal.off=0"               # Ensure thermal management is enabled
    "acpi_osi=Linux"              # Better ACPI thermal support
    "processor.ignore_ppc=1"      # Ignore processor performance control limits
    
    # Touchpad stability fixes for Surface Pro 8
    "psmouse.synaptics_intertouch=0"  # Disable problematic intertouch mode
    "i2c_hid.debug=1"                 # Better I2C HID debugging for touchpad
    "libinput.touchpad_disable_while_typing=1"  # Reduce false touches
  ];

  # Surface aggregator and GameMode GPU access udev rules
  services.udev.extraRules = ''
    # Surface aggregator device permissions
    SUBSYSTEM=="surface_aggregator", GROUP="users", MODE="0664"
    
    # Surface battery and charger permissions  
    SUBSYSTEM=="power_supply", ATTR{type}=="Battery", GROUP="users", MODE="0664"
    SUBSYSTEM=="power_supply", ATTR{type}=="Mains", GROUP="users", MODE="0664"
    
    # GPU vendor file access for GameMode (fixes GPU optimization errors)
    SUBSYSTEM=="drm", KERNEL=="card*", GROUP="gamemode", MODE="0664"
    ATTR{device/vendor}=="0x8086", GROUP="gamemode", MODE="0664"
    
    # Surface touchpad and input device permissions
    SUBSYSTEM=="input", ATTRS{name}=="Microsoft Surface*", GROUP="input", MODE="0664"
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="045e", GROUP="input", MODE="0664"
  '';
}
