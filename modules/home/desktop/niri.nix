{
  config,
  pkgs,
  ...
}:

let
  actions = config.lib.niri.actions;
in
{
  # Niri window manager configuration
  programs.niri = {
    settings = {
      prefer-no-csd = true;
      # Disable hotkey overlay on startup
      hotkey-overlay.skip-at-startup = true;

      # Environment variables for Wayland compatibility
      environment = {
        "NIXOS_OZONE_WL" = "1";
        "XDG_CURRENT_DESKTOP" = "GNOME";
        "XDG_SESSION_TYPE" = "wayland";
        "GIO_USE_VFS" = "local";
        "DISPLAY" = ":0";
        # Askpass configuration for fuzzel
        "SUDO_ASKPASS" = "/etc/nixos/modules/home/scripts/fuzzel-askpass";
        "SSH_ASKPASS_REQUIRE" = "force";
				"TERMINAL" = "kitty";
      };

      # Auto-start xwayland-satellite for X11 application support
      spawn-at-startup = [
        { command = [ "xwayland-satellite" ]; }
      ];

      animations.enable = false;

      # Window layout configuration
      layout = {
        empty-workspace-above-first = true;

				 gaps = 0;
        # center-focused-column = "never";
        # always-center-single-column = false;

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
					{ proportion = 2. / 6.; }
					{ proportion = 3. / 6.; }
					{ proportion = 4. / 6.; }
          { proportion = 6. / 6.; }
        ];
      };

      window-rules = [
        { draw-border-with-background = false; }
      ];

      # Keybindings
      binds = {
        # Application launcher and window management
        "Mod+d".action = actions.spawn ["tofi-drun" "--drun-launch=true"];
				"Mod+Space".action = actions.spawn "fuzzel";
        "Mod+Escape".action = actions.close-window;

        # Focus navigation
        "Mod+Tab".action = actions.toggle-overview;
        "Mod+Left".action = actions.focus-column-left;
        "Mod+Right".action = actions.focus-column-right;
        "Mod+Up".action = actions.focus-workspace-up;
        "Mod+Down".action = actions.focus-workspace-down;

        # Window movement
        "Mod+Shift+Left".action = actions.swap-window-left;
        "Mod+Shift+Right".action = actions.swap-window-right;
        "Mod+Shift+Up".action = actions.move-window-to-workspace-up;
        "Mod+Shift+Down".action = actions.move-window-to-workspace-down;

        "Mod+Ctrl+Tab".action = actions.switch-preset-column-width;

        # Window resizing
        "Mod+Ctrl+Left".action = actions.set-column-width "-1%";
        "Mod+Ctrl+Right".action = actions.set-column-width "+1%";
        "Mod+Ctrl+Up".action = actions.set-window-height "-1%";
        "Mod+Ctrl+Down".action = actions.set-window-height "+1%";
        "Mod+F".action = actions.maximize-column;

        # Hardware controls - brightness
        "Mod+XF86AudioRaiseVolume".action = actions.spawn [
          "brightnessctl"
          "set"
          "+5%"
        ];
        "Mod+XF86AudioLowerVolume".action = actions.spawn [
          "brightnessctl"
          "set"
          "5%-"
        ];

        # Hardware controls - audio
        "XF86AudioRaiseVolume".action = actions.spawn [
          "wpctl"
          "set-volume"
          "@DEFAULT_AUDIO_SINK@"
          "1%+"
        ];
        "XF86AudioLowerVolume".action = actions.spawn [
          "wpctl"
          "set-volume"
          "@DEFAULT_AUDIO_SINK@"
          "1%-"
        ];
        "XF86AudioMute".action = actions.spawn [
          "wpctl"
          "set-mute"
          "@DEFAULT_AUDIO_SINK@"
          "toggle"
        ];

        # Screenshot
				#"Mod+S".action = actions.spawn [ "/etc/nixos/modules/home/scripts/screenshot-interactive" ];
				"Mod+S".action = actions.screenshot;

        # OCR Screenshot - select area and extract text to clipboard
        "Mod+O".action = actions.spawn [ "/etc/nixos/modules/home/scripts/ocr-screenshot" ];

        # Temp Terminal
        "Mod+T".action = actions.spawn [
          "kitten"
          "quick-access-terminal"
        ];

        # LLM
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
  };

  # Application launcher configuration
  programs.fuzzel = {
    enable = true;
    settings = {
      main.icons-enabled = false;
    };
  };

	programs.tofi = {
		enable = true;
		settings = {
	  	anchor = "left";
			margin-top = "20%";
  		margin-left = "20%";
			width = "60%";
			height = "60%";
			outline-width=1;
			boarder-width=0;
			corner-radius=25;
			#			font-size=21;
			num-results = 0;
    	result-spacing = 4;
		};
	};
}
