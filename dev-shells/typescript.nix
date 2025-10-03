{ pkgs }: {
  name = "typescript";
  nixvim-lang-attrs = { plugins.lsp.servers.ts_ls.enable = true; };
  extra-packages = with pkgs; [ nodejs typescript nodePackages.typescript-language-server nodePackages.prettier ];
}
