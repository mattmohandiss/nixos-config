{ pkgs }: {
  name = "lua";
  extra-packages = with pkgs; [ lua-language-server stylua ];
}
