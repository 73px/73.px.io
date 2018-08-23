with import <nixpkgs> {};

{

  static = haskell.lib.justStaticExecutables ((haskellPackages.callPackage ./default.nix { }).overrideDerivation(old: {
    enableSharedExecutables = false;
    enableSharedLibraries = false;
    configureFlags = [
                   "--ghc-option=-optl=-static"
                   "--ghc-option=-optl=-pthread"
                   "--ghc-option=-optl=-L${gmp}/lib"
                   "--ghc-option=-optl=-L${gmp6.override { withStatic = true; }}/lib"
                   "--ghc-option=-optl=-L${zlib.static}/lib"
                   "--ghc-option=-optl=-L${glibc.static}/lib"
    ];
  }));

  standard = haskellPackages.callPackage ./. {};

}
