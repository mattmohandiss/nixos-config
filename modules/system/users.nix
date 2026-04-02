{ pkgs, username, fullName, ... }:

{
  users.users.${username} = {
    isNormalUser = true;
    description = fullName;
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "audio"
      "input"
    ];
    shell = pkgs.zsh;
  };
}
