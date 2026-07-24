{ config, ... }:

{
  xdg.configFile."opencode" = {
    source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/modules/home/dev/opencode";
  };
}
