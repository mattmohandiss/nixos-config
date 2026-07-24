{ pkgs, ... }:

{
  stylix = {
    enable = true;
    autoEnable = true;
    targets.kmscon.enable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";

    fonts.monospace = {
      package = pkgs.nerd-fonts.fira-code;
      name = "FiraCode Nerd Font";
    };
  };

  qt.platformTheme = "qt5ct";
}
