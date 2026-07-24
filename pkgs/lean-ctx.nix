{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lean-ctx";
  version = "3.9.3";

  src = fetchurl {
    url = "https://github.com/yvgude/lean-ctx/releases/download/v${finalAttrs.version}/lean-ctx-x86_64-unknown-linux-musl.tar.gz";
    hash = "sha256-a0QPBtQj2d0Unanh0KcK90q3PRMAoFHpC+NPMSMPqP4=";
  };

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -Dm755 lean-ctx $out/bin/lean-ctx
    runHook postInstall
  '';

  meta = {
    description = "Context engineering layer for AI agents";
    homepage = "https://github.com/yvgude/lean-ctx";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "lean-ctx";
  };
})
