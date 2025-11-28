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
  # CascadeFox theme - copy entire chrome directory
  home.file.".mozilla/firefox/default/chrome".source = "${cascadeFox}/chrome";

  # Firefox browser configuration
  programs.firefox = {
    enable = true;
    profiles.default = {
      # Browser extensions
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        bitwarden
      ];

      # Browser settings and preferences
      settings = {
        # New tab and homepage configuration
        "browser.newtabpage.enabled" = false;
        "browser.startup.homepage" = "about:blank";
        "browser.newtabpage.activity-stream.showTopSites" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;

        # Privacy and security settings
        "privacy.trackingprotection.enabled" = true;
        "dom.security.https_only_mode" = true;

        # Disable Firefox data collection and studies
        "app.shield.optoutstudies.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;

        # UI customization - hide bookmarks toolbar
        "browser.toolbars.bookmarks.visibility" = "never";

        # Custom toolbar layout (simplified)
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

        # Theme settings to match system dark theme
        "extensions.activeThemeID" = "default-theme@mozilla.org";
        "browser.theme.content-theme" = 0;
        "browser.theme.toolbar-theme" = 0;
        "ui.systemUsesDarkTheme" = 1;
        "layout.css.prefers-color-scheme.content-override" = 0;

        # Enable legacy user profile customizations for custom CSS
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };

      # Default search engine
      search = {
        default = "ddg";
        force = true;
      };
    };
  };
}
