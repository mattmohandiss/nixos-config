{ pkgs, username, fullName, homeDirectory, ... }:

{
  # User accounts
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

  programs.zsh.enable = true;

  programs.git.config = {
    global = {
      submodule.recurse = true;
    };
  };

  # Add minidlna user to users group for media access
  users.users.minidlna.extraGroups = [ "users" ];

  # Set proper permissions for home directory
  systemd.tmpfiles.rules = [ "d ${homeDirectory} 0750 ${username} users - -" ];
}
