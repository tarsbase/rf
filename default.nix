{ mkDerivation, base, filepath, hakyll, hakyll-favicon, stdenv }:
mkDerivation {
  pname = "rf";
  version = "0.1.1.1";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base filepath hakyll hakyll-favicon ];
  homepage = "regularflolloping.com";
  description = "tA's blog";
  license = stdenv.lib.licenses.bsd3;
}
