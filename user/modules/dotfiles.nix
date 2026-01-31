{ config, ... }:

{
  home.file.".config/nvim" = {
    target = ".config/nvim";
    source = config.lib.file.mkOutOfStoreSymlink
      "/etc/nixos/user/modules/development/nvim";
  };
}
