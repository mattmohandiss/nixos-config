{ config, pkgs, ... }:

{
  home.packages = [ pkgs.quickshell ];

  systemd.user.services.quickshell-pawbar = {
    Unit = {
      Description = "Quickshell system bar";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.quickshell}/bin/quickshell -c system-bar";
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  xdg.configFile = {
    "quickshell/system-bar/shell.qml".source = ./quickshell/system-bar/shell.qml;
    "quickshell/system-bar/Bar.qml".source = ./quickshell/system-bar/Bar.qml;
    "quickshell/system-bar/Metrics.qml".source = ./quickshell/system-bar/Metrics.qml;
    "quickshell/system-bar/Metric.qml".source = ./quickshell/system-bar/Metric.qml;
    "quickshell/system-bar/Theme.qml".text = ''
      import QtQuick

      QtObject {
          readonly property color background: "#${config.lib.stylix.colors.base00}"
          readonly property color foreground: "#${config.lib.stylix.colors.base05}"
          readonly property color error: "#${config.lib.stylix.colors.base08}"
          readonly property color warning: "#${config.lib.stylix.colors.base0A}"
          readonly property string fontFamily: "${config.stylix.fonts.monospace.name}"
      }
    '';

    "wlogout/layout".text = builtins.toJSON [
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

    "wlogout/style.css".text = ''
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
  };
}
