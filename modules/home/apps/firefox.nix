{ browserDefaults, inputs, ... }:

{
  home.file.".mozilla/firefox/default/chrome".source = "${inputs.cascadefox}/chrome";

  programs.firefox = {
    enable = true;
    profiles.default = {
      extensions.packages = browserDefaults.extensions;

      settings = browserDefaults.commonSettings // browserDefaults.themeSettings // {
        "app.shield.optoutstudies.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
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
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "extensions.activeThemeID" = "default-theme@mozilla.org";
      };

      search = {
        default = "ddg";
        force = true;
      };
    };
  };
}
