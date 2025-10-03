{ pkgs }: {
  name = "nix";
  nixvim-lang-attrs = { plugins.lsp.servers.nil_ls.enable = true; };
  extra-packages = with pkgs; [ nil nixd nixfmt-rfc-style ];
}
