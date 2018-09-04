let
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
   pkgs = import <nixpkgs> { inherit config; };
in
   rec {
      inherit pkgs;
      rf = pkgs.haskellPackages.rf;
   }
