{ pkgs }: {
  name = "haskell";
  nixvim-lang-attrs = { plugins.lsp.servers.hls.enable = true; };
  extra-packages = with pkgs; [ haskell.compiler.ghc98 cabal-install haskell-language-server ];
}
