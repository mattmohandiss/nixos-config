{ pkgs }: {
  name = "haskell";
  extra-packages = with pkgs; [ haskell.compiler.ghc98 cabal-install haskell-language-server ];
}
