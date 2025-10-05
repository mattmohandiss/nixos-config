{ pkgs }: {
  name = "lua";
  extra-packages = with pkgs; [ lua lua-language-server stylua ];
}
