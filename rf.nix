let
   inherit (import <nixpkgs> {}) fetchFromGitHub;
   np = fetchFromGitHub {
     owner = "NixOS";
     repo = "nixpkgs";
     rev = "d7c0d9a7f83b7f80e08888c040ea8a2ab7ca5f71";
     sha256 = "0vb7ikjscrp2rw0dfw6pilxqpjm50l5qg2x2mn1vfh93dkl2aan7";
   };
   config = {
      packageOverrides = pkgs: rec {
         haskellPackages = pkgs.haskellPackages.override {
            overrides = haskellPackagesNew: haskellPackagesOld: rec {
               rf =
                  haskellPackagesNew.callPackage ./default.nix { };
            };
         };
      };
   };
   pkgs = import np { inherit config; };
in
   rec {
      inherit pkgs;
      rf = pkgs.haskellPackages.rf;
   }
