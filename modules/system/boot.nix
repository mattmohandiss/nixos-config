{ config, pkgs, ... }:

{
  # Bootloader (Microsoft Surface configuration handled by nixos-hardware)
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.memtest86.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Surface Pro 8 keyboard support for LUKS password entry
  boot.initrd.kernelModules = [
    "hid"
    "usbhid"
    "hid_generic"
    "i2c-hid"
  ];
  boot.initrd.availableKernelModules = [
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

  # Crash dump configuration (disable NixOS module to avoid aggressive panic settings)
  boot.crashDump.enable = false;

  # Kernel parameters optimized for Surface Pro
  boot.kernelParams = [
    "mem_sleep_default=deep" # Prefer deep sleep over s2idle
    "crashkernel=128M" # Reduced crash kernel memory reservation
    "panic=10" # Reboot after 10 seconds on panic (more time to see error)
    "panic_on_warn=0" # Don't panic on warnings
    "nmi_watchdog=panic" # Only panic on NMI watchdog, not soft lockups
    "printk.devkmsg=on" # Enable /dev/kmsg for userspace logging
    "log_buf_len=1M" # Increase kernel log buffer size
    "loglevel=4" # Set appropriate log level (KERN_WARNING and above)
  ];
}
