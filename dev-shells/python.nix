{ pkgs }: {
  name = "python";
  extra-packages = with pkgs; [ python3 pyright black ];
}
