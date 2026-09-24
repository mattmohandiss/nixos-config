{ config, username, ... }:

{
  sops.secrets.searx-secret = {
    sopsFile = ../../secrets/surface.yaml;
    owner = "root";
    mode = "0400";
  };

  sops.templates."searxng-secret.env".content = ''
    SEARXNG_SECRET=${config.sops.placeholder.searx-secret}
  '';

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
    ollama.enable = true;

    searx = {
      enable = true;
      redisCreateLocally = true;
      environmentFile = config.sops.templates."searxng-secret.env".path;

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
