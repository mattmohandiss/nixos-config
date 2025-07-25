{ pkgs, ... }:

{
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
      };

      # Default search engine
      search = {
        default = "ddg";
        force = true;
      };
    };
  };
}
