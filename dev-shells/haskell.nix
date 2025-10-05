{ pkgs }: {
  name = "haskell";
  extra-packages = with pkgs; [ ghc haskell.compiler.ghc98 cabal-install haskell-language-server ];
}
