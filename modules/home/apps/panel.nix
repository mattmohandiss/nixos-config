_:
{
  stylix.targets.waybar = {
    enable = true;
    addCss = true;
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      main = {
        layer = "top";
        position = "top";
        height = 32;
        spacing = 6;
        modules-left = [ "niri/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [
          "tray"
          "network"
          "pulseaudio"
          "backlight"
          "battery"
          "cpu"
          "memory"
          "custom/power"
        ];

        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            active = "";
            default = "";
          };
          all-outputs = true;
        };

        clock = {
          format = "{:%a %b %d  %H:%M}";
          tooltip-format = "<tt>{calendar}</tt>";
          interval = 1;
          on-click = "kitty --class calendar -e cal";
        };

        tray = {
          spacing = 8;
          icon-size = 16;
        };

        network = {
          format-wifi = "  {essid}";
          format-ethernet = "󰈀  {ipaddr}";
          format-disconnected = "󰤮  offline";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}";
          on-click = "kitty --class network -e nmtui";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰖁 muted";
          format-icons = {
            default = [ "" "" "" ];
          };
          on-click = "pwvucontrol";
          on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          scroll-step = 1;
        };

        backlight = {
          format = "{icon} {percent}%";
          format-icons = [ "󰃞" "󰃟" "󰃠" ];
          on-scroll-up = "brightnessctl set 1%+";
          on-scroll-down = "brightnessctl set 1%-";
        };

        battery = {
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" ];
          states = {
            warning = 30;
            critical = 15;
          };
        };

        cpu = {
          format = " {usage}%";
          interval = 2;
          on-click = "kitty --class btop -e btop";
        };

        memory = {
          format = " {percentage}%";
          interval = 2;
          on-click = "kitty --class btop -e btop";
        };

        "custom/power" = {
          format = "⏻";
          tooltip = false;
          on-click = "wlogout";
        };
      };
    };
  };

  xdg.configFile."wlogout/layout".text = builtins.toJSON [
    {
      label = "shutdown";
      action = "systemctl poweroff";
      text = "Shutdown";
      keybind = "s";
    }
    {
      label = "reboot";
      action = "systemctl reboot";
      text = "Restart";
      keybind = "r";
    }
    {
      label = "hibernate";
      action = "systemctl hibernate";
      text = "Hibernate";
      keybind = "h";
    }
    {
      label = "logout";
      action = "niri msg action quit --skip-confirmation";
      text = "Logout";
      keybind = "l";
    }
  ];

  xdg.configFile."wlogout/style.css".text = ''
    * {
      background-image: none;
      box-shadow: none;
      font-family: "Cantarell", sans-serif;
      font-size: 18px;
    }

    window {
      background-color: rgba(20, 24, 30, 0.8);
    }

    button {
      color: #e8edf2;
      background-color: #283341;
      border: 2px solid #36485e;
      border-radius: 12px;
      margin: 12px;
      padding: 20px 28px;
      transition: background-color 120ms ease-in-out;
    }

    button:hover,
    button:focus {
      background-color: #3a4f68;
      border-color: #8aa3c2;
    }
  '';
}
