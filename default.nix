{ mkDerivation, base, binary, filepath, hakyll, hakyll-favicon, imagemagick
, stdenv
}:
mkDerivation {
  pname = "rf";
  version = "0.1.3.1";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base binary filepath hakyll hakyll-favicon ];
  #executableSystemDepends = [ imagemagick ];
  homepage = "regularflolloping.com";
  description = "tA's blog";
  license = stdenv.lib.licenses.bsd3;
}
