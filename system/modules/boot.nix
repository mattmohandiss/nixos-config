{ config, pkgs, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.memtest86.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
    };
    initrd = {
      kernelModules = [
        "usbhid"
        "hid"
      ];
      availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "intel_lpss_pci"
        "i2c_designware_platform"
        "i2c_hid"
        "pinctrl_tigerlake"
        "8250_dw"
        "surface_gpe"
        "surface_hotplug"
        "surface_aggregator_registry"
        "surface_aggregator_hub"
        "surface_aggregator"
        "surface_hid_core"
        "surface_hid"
        "surface_kbd"
      ];
    };
    kernelModules = [
      "surface_aggregator"
      "surface_hid_core"
      "surface_hid"
      "surface_kbd"
    ];
    crashDump.enable = false;
    kernelParams = [
      "mem_sleep_default=deep"
      "crashkernel=128M"
      "panic=10"
      "panic_on_warn=0"
      "nmi_watchdog=panic"
      "printk.devkmsg=on"
      "log_buf_len=1M"
      "loglevel=4"
      "i915.enable_psr=0"
      "nvme_core.default_ps_max_latency_us=0"
    ];
  };
}
