{ config
, lib
, pkgs
, modulesPath
, ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "nvme"
      ];
      kernelModules = [ ];
      luks.devices = {
        "luks-b94931ce-7734-4097-a602-2571d626439f".device =
          "/dev/disk/by-uuid/b94931ce-7734-4097-a602-2571d626439f";
        "luks-0fd5c9ce-48db-4b98-bfc5-36d0124dc20a".device =
          "/dev/disk/by-uuid/0fd5c9ce-48db-4b98-bfc5-36d0124dc20a";
      };
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/20001560-ba5a-44dd-89c2-f23029f97e66";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/88C6-D6DA";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [{ device = "/dev/mapper/luks-0fd5c9ce-48db-4b98-bfc5-36d0124dc20a"; }];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
