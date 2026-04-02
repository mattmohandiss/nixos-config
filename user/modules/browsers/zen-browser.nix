{ pkgs, ... }:

let
  firefoxExtensionsDir = "share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}";
  ublockOrigin = pkgs.nur.repos.rycee.firefox-addons.ublock-origin;
  bitwarden = pkgs.nur.repos.rycee.firefox-addons.bitwarden;
in
{
  programs.zen-browser = {
    enable = true;

    policies = {
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

      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "file://${ublockOrigin}/${firefoxExtensionsDir}/uBlock0@raymondhill.net.xpi";
          installation_mode = "force_installed";
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "file://${bitwarden}/${firefoxExtensionsDir}/{446900e4-71c2-419f-a6a7-df9c091e268b}.xpi";
          installation_mode = "force_installed";
        };
      };

      Preferences = {
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

        "privacy.trackingprotection.enabled" = {
          Value = true;
          Status = "locked";
        };
        "dom.security.https_only_mode" = {
          Value = true;
          Status = "locked";
        };

        "browser.toolbars.bookmarks.visibility" = {
          Value = "never";
          Status = "locked";
        };

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

        "browser.tabs.closeWindowWithLastTab" = {
          Value = false;
          Status = "locked";
        };

        "browser.backspace_action" = {
          Value = 0;
          Status = "locked";
        };

        "browser.ctrlTab.recentlyUsedOrder" = {
          Value = false;
          Status = "locked";
        };

        "accessibility.tabfocus" = {
          Value = 7;
          Status = "locked";
        };

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
