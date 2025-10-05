{ pkgs }: {
  name = "nix";
  extra-packages = with pkgs; [ nil nixd nixfmt-rfc-style nix-output-monitor ];
}
