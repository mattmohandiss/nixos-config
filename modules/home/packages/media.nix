{ pkgs, ... }:

{
  home.packages = with pkgs; [
    mpv
    gimp
    blender
    poppler-utils
    tesseract
    zathura
    stremio-linux-shell
    freecad
  ];
}
