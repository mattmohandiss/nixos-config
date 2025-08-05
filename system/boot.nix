{ config, pkgs, ... }:

{
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Surface Pro 8 keyboard support for LUKS password entry
  boot.initrd.kernelModules = [ "hid" "usbhid" "hid_generic" "i2c-hid" ];
  boot.initrd.availableKernelModules = [
    # Hardware-detected modules
    "xhci_pci" "thunderbolt" "nvme" "usbhid" "usb_storage" "sd_mod"
    # Intel platform support
    "intel_lpss_pci" 
    "i2c_designware_platform" 
    "i2c_hid"
    # Surface-specific modules for keyboard support during LUKS
    "pinctrl_tigerlake"           # Critical for Tiger Lake pin control
    "8250_dw"                     # DesignWare 8250 serial driver
    "surface_gpe"                 # Surface GPE support
    "surface_hotplug"             # Surface hotplug support
    "surface_aggregator_registry" # Surface aggregator registry
    "surface_aggregator_hub"      # Surface aggregator hub
    "surface_aggregator"          # Main Surface aggregator driver
    "surface_hid_core"            # Surface HID core
    "surface_hid"                 # Surface HID driver
    "surface_kbd"                 # Surface keyboard driver
  ];

  # Disk Encryption
  boot.initrd.luks.devices."luks-0fd5c9ce-48db-4b98-bfc5-36d0124dc20a".device =
    "/dev/disk/by-uuid/0fd5c9ce-48db-4b98-bfc5-36d0124dc20a";

  # Crash dump support for debugging system crashes
  boot.crashDump.enable = true;
  boot.kernelParams = [ "crashkernel=256M" ];
}
