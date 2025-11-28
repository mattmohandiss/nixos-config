{ pkgs, ... }:

{
  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;
      ignore-timeout = true;
      anchor = "top-right";
      margin = "10";
      border-radius = 5;
      actions = true;
    };
  };
}
