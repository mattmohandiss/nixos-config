{ config, pkgs, ... }:

{
  # Enable all firmware for Surface Pro 8 support
  hardware.enableAllFirmware = true;

  # Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Surface Pro 8 stability optimizations
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
  ];
}
