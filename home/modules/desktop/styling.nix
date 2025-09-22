{ pkgs, ... }:

{
  # System-wide theming with Stylix
  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    
    # Font configuration
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font";
      };
    };
    
    # Application-specific styling targets
    targets.firefox.profileNames = [ "default" ];
    targets.kde.enable = true;
  };

  # Font configuration
  fonts.fontconfig.enable = true;

  # Mako notification daemon (styled by stylix)
  services.mako = {
    enable = true;
    defaultTimeout = 5000;
    ignoreTimeout = true;
    
    # Position and basic settings
    anchor = "top-right";
    margin = "10";
    borderRadius = 5;
    
    # Enable actions for interactive notifications
    actions = true;
    
    # Custom configuration for screenshot notifications
    extraConfig = ''
      # Screenshot notification handling
      [category=screenshot]
      on-button-left=invoke-default-action
    '';
  };
}
