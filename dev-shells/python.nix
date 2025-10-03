{ pkgs }: {
  name = "python";
  nixvim-lang-attrs = { plugins.lsp.servers.pyright.enable = true; };
  extra-packages = with pkgs; [ python3 pyright black ];
}
