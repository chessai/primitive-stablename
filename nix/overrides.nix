{ pkgs }:

self: super:

with { inherit (pkgs.stdenv) lib; };

with pkgs.haskell.lib;

{
  primitive-stablename = (
    with rec {
      primitive-stablenameSource = pkgs.lib.cleanSource ../.;
      primitive-stablenameBasic  = self.callCabal2nix "primitive-stablename" primitive-stablenameSource { };
    };
    overrideCabal primitive-stablenameBasic (old: {
    })
  );
}
