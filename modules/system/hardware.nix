{ pkgs, ... }:

{
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
      ];
    };

    xpadneo.enable = true;
    sensor.iio.enable = true;
  };

}
