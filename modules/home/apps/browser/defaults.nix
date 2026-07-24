{ pkgs, ... }:

{
  _module.args.browserDefaults = {
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      bitwarden
    ];

    commonSettings = {
      "browser.newtabpage.enabled" = false;
      "browser.startup.homepage" = "about:blank";
      "browser.newtabpage.activity-stream.showTopSites" = false;
      "browser.newtabpage.activity-stream.feeds.topsites" = false;
      "privacy.trackingprotection.enabled" = true;
      "dom.security.https_only_mode" = true;
      "browser.toolbars.bookmarks.visibility" = "never";
    };

    themeSettings = {
      "ui.systemUsesDarkTheme" = 1;
      "browser.theme.content-theme" = 0;
      "browser.theme.toolbar-theme" = 0;
      "layout.css.prefers-color-scheme.content-override" = 0;
    };
  };

  stylix = {
    polarity = "dark";
    targets = {
      firefox.profileNames = [ "default" ];
      "zen-browser".profileNames = [ "Default Profile" ];
    };
  };
}
