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
}
