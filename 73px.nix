{ mkDerivation, base, blaze-html, filepath, optparse-applicative
, scotty, stdenv, text, wai-extra, wai-middleware-static
}:
mkDerivation {
  pname = "73px";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base blaze-html filepath optparse-applicative scotty text wai-extra
    wai-middleware-static
  ];
  homepage = "https://73.px.io";
  license = stdenv.lib.licenses.bsd3;
}
