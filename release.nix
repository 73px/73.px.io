with import <nixpkgs> {};

let

  defaultnix = runCommand "generate-default-nix" {
    buildCommand = ''
      cabal2nix ${./.} > "$out"
    '';
    buildInputs = with pkgs; [ cabal2nix ];
  } "";

in {

  static = haskell.lib.justStaticExecutables ((haskellPackages.callPackage (defaultnix) { }).overrideDerivation(old: {
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

  standard = haskellPackages.callPackage (defaultnix) {};

}
