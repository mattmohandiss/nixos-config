{ pkgs }: {
  name = "go";
  extra-packages = with pkgs; [ go gopls ];
}
