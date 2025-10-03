{ pkgs }: {
  name = "go";
  nixvim-lang-attrs = { plugins.lsp.servers.gopls.enable = true; };
  extra-packages = with pkgs; [ go gopls ];
}
