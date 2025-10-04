{ pkgs }: {
  name = "typescript";
  extra-packages = with pkgs; [ nodejs typescript nodePackages.typescript-language-server nodePackages.prettier ];
}
