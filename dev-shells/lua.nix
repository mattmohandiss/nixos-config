{ pkgs }: {
  name = "lua";
  nixvim-lang-attrs = { plugins.lsp.servers.lua-ls.enable = true; };
  extra-packages = with pkgs; [ lua-language-server stylua ];
}
