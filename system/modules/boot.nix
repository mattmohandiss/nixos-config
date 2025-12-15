{ config, pkgs, ... }:

{
  # Bootloader (Microsoft Surface configuration handled by nixos-hardware)
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.memtest86.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
    };
    # Surface Pro 8 keyboard support for LUKS password entry
    initrd = {
      kernelModules = [
        "usbhid"
        "hid"
      ];
      # Essential Surface modules for detachable keyboard during LUKS decryption
      availableKernelModules = [
        # Hardware-detected modules
        "xhci_pci"
        "thunderbolt"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
        # Intel platform support
        "intel_lpss_pci"
        "i2c_designware_platform"
        "i2c_hid"
        # Surface-specific modules for keyboard support during LUKS
        "pinctrl_tigerlake" # Critical for Tiger Lake pin control
        "8250_dw" # DesignWare 8250 serial driver
        "surface_gpe" # Surface GPE support
        "surface_hotplug" # Surface hotplug support
        "surface_aggregator_registry" # Surface aggregator registry
        "surface_aggregator_hub" # Surface aggregator hub
        "surface_aggregator" # Main Surface aggregator driver
        "surface_hid_core" # Surface HID core
        "surface_hid" # Surface HID driver
        "surface_kbd" # Surface keyboard driver
      ];
    };
    # Kernel modules for Surface hardware initialization
    kernelModules = [
      "surface_aggregator"
      "surface_hid_core"
      "surface_hid"
      "surface_kbd"
    ];
    # Crash dump configuration (disable NixOS module to avoid aggressive panic settings)
    crashDump.enable = false;
    # Kernel parameters optimized for Surface Pro
    kernelParams = [
      "mem_sleep_default=deep" # Prefer deep sleep over s2idle
      "crashkernel=128M" # Reduced crash kernel memory reservation
      "panic=10" # Reboot after 10 seconds on panic (more time to see error)
      "panic_on_warn=0" # Don't panic on warnings
      "nmi_watchdog=panic" # Only panic on NMI watchdog, not soft lockups
      "printk.devkmsg=on" # Enable /dev/kmsg for userspace logging
      "log_buf_len=1M" # Increase kernel log buffer size
      "loglevel=4" # Set appropriate log level (KERN_WARNING and above)
      "i915.enable_psr=0" # Disable Panel Self Refresh to prevent flickering
      "nvme_core.default_ps_max_latency_us=0" # Disable NVMe APST to prevent SSD power state issues
    ];
  };
}
