{
  config,
  pkgs,
  inputs,
  ...
}:

{
  programs.gpg = {
    enable = true;
  };
}
