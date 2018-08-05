with import <nixpkgs> {};

(haskellPackages.callPackage ./73px.nix {}).overrideDerivation(old: {
  postInstall = ''
    cp -rf static $out/bin/
  '';
})
