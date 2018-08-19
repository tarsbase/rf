{ mkDerivation, base, filepath, hakyll, stdenv }:
mkDerivation {
  pname = "rf";
  version = "0.1.0.1";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base filepath hakyll ];
  homepage = "regularflolloping.com";
  description = "tA's blog";
  license = stdenv.lib.licenses.bsd3;
}
