{ config, pkgs, inputs, ... }:

let
  inherit (config.lib.niri) actions;
  selfScripts = "${inputs.self}/scripts";
  pawbarPkg = pkgs.buildGoModule {
    pname = "pawbar";
    version = "0-unstable";
    src = inputs.pawbar.outPath;
    subPackages = [ "." ];
    vendorHash = "sha256-DUjfFrmpjSUWDicncTXvL1mnnPqEEKGyz6PTLEnGD7E=";
    buildInputs = with pkgs; [
      udev
      librsvg
      cairo
    ];
    nativeBuildInputs = with pkgs; [ pkg-config ];
  };
in
{
  programs = {
    niri.settings = {
      prefer-no-csd = true;

      hotkey-overlay.skip-at-startup = true;

      input.power-key-handling.enable = false;

      environment = {
        NIXOS_OZONE_WL = "1";
        XDG_CURRENT_DESKTOP = "GNOME";
        XDG_SESSION_TYPE = "wayland";
        GIO_USE_VFS = "local";
        DISPLAY = ":0";
        SUDO_ASKPASS = "${selfScripts}/fuzzel-askpass";
        SSH_ASKPASS_REQUIRE = "force";
        TERMINAL = "kitty";
      };

      spawn-at-startup = [ ];

      animations.slowdown = 0.25;

      layout = {
        empty-workspace-above-first = true;
        gaps = 0;

        border = {
          enable = true;
          width = 1;
        };

        focus-ring = {
          enable = false;
          width = 1;
        };

        default-column-width = { };

        preset-column-widths = [
          { proportion = 2.0 / 6; }
          { proportion = 3.0 / 6; }
          { proportion = 4.0 / 6; }
          { proportion = 6.0 / 6; }
        ];
      };

      window-rules = [{ draw-border-with-background = false; }];

      binds = {
        "Mod+d".action = actions.spawn [ "tofi-drun" "--drun-launch=true" ];
        "Mod+Space".action = actions.spawn "fuzzel";
        "Mod+Escape".action = actions.close-window;

        "Mod+Tab".action = actions.toggle-overview;
        "Mod+Left".action = actions.focus-column-left;
        "Mod+Right".action = actions.focus-column-right;
        "Mod+Up".action = actions.focus-workspace-up;
        "Mod+Down".action = actions.focus-workspace-down;

        "Mod+Shift+Left".action = actions.swap-window-left;
        "Mod+Shift+Right".action = actions.swap-window-right;
        "Mod+Shift+Up".action = actions.move-window-to-workspace-up;
        "Mod+Shift+Down".action = actions.move-window-to-workspace-down;

        "Mod+Ctrl+Tab".action = actions.switch-preset-column-width;

        "Mod+Ctrl+Left".action = actions.set-column-width "-1%";
        "Mod+Ctrl+Right".action = actions.set-column-width "+1%";
        "Mod+Ctrl+Up".action = actions.set-window-height "-1%";
        "Mod+Ctrl+Down".action = actions.set-window-height "+1%";
        "Mod+F".action = actions.maximize-column;

        "Mod+XF86AudioRaiseVolume".action =
          actions.spawn [ "brightnessctl" "set" "+5%" ];
        "Mod+XF86AudioLowerVolume".action =
          actions.spawn [ "brightnessctl" "set" "5%-" ];

        "XF86AudioRaiseVolume".action =
          actions.spawn [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "1%+" ];
        "XF86AudioLowerVolume".action =
          actions.spawn [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "1%-" ];
        "XF86AudioMute".action =
          actions.spawn [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ];

        "Mod+S".action = actions.spawn [ "${selfScripts}/screenshot-interactive" ];
        "Mod+Shift+S".action = actions.spawn [ "${selfScripts}/screenshot-interactive" "--raw" ];

        "Mod+O".action = actions.spawn [ "${selfScripts}/ocr-screenshot" ];

        "Mod+T".action = actions.spawn [ "kitten" "quick-access-terminal" ];

        "Mod+L".action = actions.spawn [
          "kitten"
          "quick-access-terminal"
          "uv"
          "tool"
          "run"
          "llm"
          "chat"
        ];
      };
    };

    fuzzel = {
      enable = true;
      settings.main.icons-enabled = false;
    };

    tofi = {
      enable = true;
      settings = {
        anchor = "left";
        margin-top = "20%";
        margin-left = "20%";
        width = "60%";
        height = "60%";
        outline-width = 1;
        border-width = 0;
        corner-radius = 25;
        num-results = 0;
        result-spacing = 4;
      };
    };
  };

  systemd.user.services.pawbar = {
    Unit = {
      Description = "Pawbar panel";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pawbarPkg}/bin/pawbar";
      Restart = "on-failure";
      RestartSec = 5;
      KillMode = "process";
      TimeoutStopSec = 10;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
