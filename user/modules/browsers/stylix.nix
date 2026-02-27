{
  config,
  pkgs,
  inputs,
  ...
}:

{
  stylix = {
    polarity = "dark";
    targets = {
      firefox = {
        profileNames = [ "default" ];
      };
      "zen-browser" = {
        profileNames = [ "Default Profile" ];
      };
    };
  };
}
