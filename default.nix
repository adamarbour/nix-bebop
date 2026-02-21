{ sources ? import ./lon.nix }:
let
  overlays = import ./overlays { inherit sources; };
  pkgs = import sources.nixpkgs {
    system = builtins.currentSystem;
    overlays = [ overlays.default ];
  };
  lib = pkgs.lib;
in {
  inherit sources pkgs lib;
}
