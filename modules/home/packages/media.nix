{ pkgs, ... }:

{
  home.packages = with pkgs; [
    mpv
    gimp
    blender
    poppler-utils
    tesseract
    zathura
    freecad
  ];
}
