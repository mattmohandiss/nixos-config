{ pkgs, ... }:

let
  cascadeFox = pkgs.fetchFromGitHub {
    owner = "cascadefox";
    repo = "cascade";
    rev = "main";
    sha256 = "sha256-adhwQpPb69wT5SZTmu7VxBbFpM4NNAuz4258k46T4K0=";
  };
in
{
  home.file.".mozilla/firefox/default/chrome".source = "${cascadeFox}/chrome";

  programs.firefox = {
    enable = true;
    profiles.default = {
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        bitwarden
      ];

      settings = {
        "browser.newtabpage.enabled" = false;
        "browser.startup.homepage" = "about:blank";
        "browser.newtabpage.activity-stream.showTopSites" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;

        "privacy.trackingprotection.enabled" = true;
        "dom.security.https_only_mode" = true;

        "app.shield.optoutstudies.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;

        "browser.toolbars.bookmarks.visibility" = "never";

        "browser.uiCustomization.state" = builtins.toJSON {
          placements = {
            widget-overflow-fixed-list = [
              "fxa-toolbar-menu-button"
              "sync-button"
            ];
            nav-bar = [
              "back-button"
              "forward-button"
              "stop-reload-button"
              "urlbar-container"
              "downloads-button"
              "unified-extensions-button"
            ];
          };
          currentVersion = 20;
        };

        "extensions.activeThemeID" = "default-theme@mozilla.org";
        "browser.theme.content-theme" = 0;
        "browser.theme.toolbar-theme" = 0;
        "ui.systemUsesDarkTheme" = 1;
        "layout.css.prefers-color-scheme.content-override" = 0;

        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };

      search = {
        default = "ddg";
        force = true;
      };
    };
  };
}
