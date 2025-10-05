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
    settings = {
      default-timeout = 5000;
      ignore-timeout = true;
      anchor = "top-right";
      margin = "10";
      border-radius = 5;
      actions = true;
      "[category=screenshot]" = {
      };
    };
  };
}
