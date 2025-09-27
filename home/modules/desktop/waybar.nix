{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = {
      mainBar = {
        spacing = 8;
        fixed-center = true;

        modules-left = [
          "cpu"
          "memory"
          "disk"
          "temperature"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "network"
          "wireplumber"
          "backlight"
          "battery"
        ];

        clock = {
          interval = 1;
          timezone = "";
          tooltip-format = "{:%a %b %d %Y}";
          format = "{:%H:%M:%S}";
        };

        network = {
          format-wifi = "󰤨{signalStrength}%";
          format-ethernet = "󰈀Connected";
          tooltip-format = "{essid}";
          format-linked = "󱘖{ifname} (No IP)";
          format-disconnected = "Disconnected";
          on-click = "nm-connection-editor";
        };

        wireplumber = {
          format = "{icon}{volume}%";
          format-bluetooth = "{icon}{volume}%";
          format-bluetooth-muted = "{icon}0%";
          format-muted = "󰖁0%";
          format-source = "{volume}%";
          format-source-muted = "󰝟";
          format-icons = {
            headphone = "";
            default = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
          };
          on-click = "pwvucontrol";
        };

        backlight = {
          device = "intel_backlight";
          format = "{icon}{percent}%";
          format-icons = ["󰃞" "󰃟" "󰃠"];
          on-scroll-up = "brightnessctl set +1%";
          on-scroll-down = "brightnessctl set 1%-";
          tooltip = false;
        };

        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon}{capacity}%";
          format-charging = "󱐋{capacity}%";
          format-plugged = "󰚥{capacity}%";
          tooltip-format = "{time}";
          format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        };

        cpu = {
          format = "{usage}%";
          tooltip-format = "{load}";
          on-click = "htop";
        };

        memory = {
          format = "{}%";
          tooltip-format = "{used}/{total}";
        };

        disk = {
          interval = 30;
          format = "{percentage_used}%";
          path = "/";
          tooltip-format = "{used}/{total}";
          on-click = "filelight";
        };

        temperature = {
          thermal-zone = 0;
          format = "{icon}{temperatureF}°";
          critical-threshold = 180;
          format-critical = "{icon}{temperatureF}°";
          format-icons = ["" "" "" ""];
        };

      };
    };

    style = ''
      * {
        font-family: "FiraCode Nerd Font Mono";
        font-size: 14px;
        padding: 2px;
      }
    '';
  };
}
