{ config, pkgs, ... }:

{
  # User accounts
  users.users.mattm = {
    isNormalUser = true;
    description = "Matt Mohandiss";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "audio"
      "input"
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  programs.git.config = {
    global = {
      submodule.recurse = true;
    };
  };

  # Add minidlna user to users group for media access
  users.users.minidlna.extraGroups = [ "users" ];

  # Set proper permissions for home directory
  systemd.tmpfiles.rules = [ "d /home/mattm 0750 mattm users - -" ];
}
