_:

{
  boot.initrd.availableKernelModules = [
    "surface_gpe"
    "surface_hotplug"
    "surface_aggregator_registry"
    "surface_aggregator_hub"
    "surface_aggregator"
    "surface_hid_core"
    "surface_hid"
    "surface_kbd"
  ];

  boot.kernelModules = [
    "surface_aggregator"
    "surface_hid_core"
    "surface_hid"
    "surface_kbd"
  ];

  services = {
    udev.extraRules = ''
      # Keep the Intel AX201 Bluetooth USB function awake for BLE gamepads.
      ACTION=="add|change", SUBSYSTEM=="usb", ATTR{idVendor}=="8087", ATTR{idProduct}=="0026", ATTR{power/control}="on"
    '';

    iptsd.enable = true;
  };
}
