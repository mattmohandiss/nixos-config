{ pkgs, inputs, ... }:

{
  # Zen browser configuration with Home Manager
  programs.zen-browser = {
    enable = true;
    
    policies = {
      # Privacy and security settings (matching Firefox configuration)
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      
      # Extensions (matching Firefox setup)
      ExtensionSettings = {
        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        # Bitwarden
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
      };
      
      # Preferences (matching Firefox settings)
      Preferences = {
        # New tab and homepage configuration
        "browser.newtabpage.enabled" = {
          Value = false;
          Status = "locked";
        };
        "browser.startup.homepage" = {
          Value = "about:blank";
          Status = "locked";
        };
        "browser.newtabpage.activity-stream.showTopSites" = {
          Value = false;
          Status = "locked";
        };
        "browser.newtabpage.activity-stream.feeds.topsites" = {
          Value = false;
          Status = "locked";
        };
        
        # Privacy and security settings
        "privacy.trackingprotection.enabled" = {
          Value = true;
          Status = "locked";
        };
        "dom.security.https_only_mode" = {
          Value = true;
          Status = "locked";
        };
        
        # UI customization
        "browser.toolbars.bookmarks.visibility" = {
          Value = "never";
          Status = "locked";
        };
        
        # Theme settings to match system dark theme
        "ui.systemUsesDarkTheme" = {
          Value = 1;
          Status = "locked";
        };
        "browser.theme.content-theme" = {
          Value = 0;
          Status = "locked";
        };
        "browser.theme.toolbar-theme" = {
          Value = 0;
          Status = "locked";
        };
        "layout.css.prefers-color-scheme.content-override" = {
          Value = 0;
          Status = "locked";
        };
        
        # Custom keybindings
        # Enable custom keyboard shortcuts
        "browser.tabs.closeWindowWithLastTab" = {
          Value = false;
          Status = "locked";
        };
        
        # Navigation preferences for Alt+Left/Right
        "browser.backspace_action" = {
          Value = 0;
          Status = "locked";
        };
        
        # Tab switching preferences for Alt+Up/Down
        "browser.ctrlTab.recentlyUsedOrder" = {
          Value = false;
          Status = "locked";
        };
        
        # Enable advanced keyboard handling
        "accessibility.tabfocus" = {
          Value = 7;
          Status = "locked";
        };
        
        # Custom key event handling
        "dom.keyboardevent.keypress.hack.dispatch_non_printable_keys" = {
          Value = true;
          Status = "locked";
        };
        
        "dom.keyboardevent.keypress.hack.use_legacy_keycode_and_charcode" = {
          Value = true;
          Status = "locked";
        };
      };
    };
  };
}
