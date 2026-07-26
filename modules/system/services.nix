{ username, ... }:

{
  security.rtkit.enable = true;

  powerManagement.enable = true;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    autoPrune.enable = true;
    autoPrune.dates = "weekly";
  };

  users.users.${username}.extraGroups = [ "docker" ];

  services = {
    searx = {
      enable = true;
      redisCreateLocally = true;
      environmentFile = "/etc/searxng/secret.env";

      settings = {
        search.formats = [ "html" "json" ];

        server = {
          bind_address = "127.0.0.1";
          port = 8080;
          secret_key = "$SEARXNG_SECRET";
        };
      };
    };

    power-profiles-daemon.enable = true;
    thermald.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    logind.settings.Login = {
      HandlePowerKey = "ignore";
      HandlePowerKeyLongPress = "poweroff";
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "ignore";
      HandleLidSwitchDocked = "ignore";
    };

    upower = {
      enable = true;
      percentageLow = 20;
      percentageCritical = 5;
      percentageAction = 3;
      criticalPowerAction = "Hibernate";
    };

    fwupd.enable = true;
  };
}
