{ mkDerivation, base, filepath, hakyll, hakyll-favicon, imagemagick
, stdenv
}:
mkDerivation {
  pname = "rf";
  version = "0.1.2.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base filepath hakyll hakyll-favicon ];
  executableSystemDepends = [ imagemagick ];
  homepage = "regularflolloping.com";
  description = "tA's blog";
  license = stdenv.lib.licenses.bsd3;
}
