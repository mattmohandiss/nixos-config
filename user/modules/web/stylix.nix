{
  config,
  pkgs,
  inputs,
  ...
}:

{
  stylix = {
    targets = {
      firefox = {
        profileNames = [ "default" ];
      };
      "zen-browser" = {
        profileNames = [ "default" ];
      };
    };
  };
}
