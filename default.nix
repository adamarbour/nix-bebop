{ sources ? import ./lon.nix }:
let
  overlays = import ./overlays { inherit sources; };
  pkgs = import sources.nixpkgs {
    system = builtins.currentSystem;
    overlays = [ overlays.default ];
  };
  lib = pkgs.lib.extend ( final: prev: {
    bebop = import ./lib/bebop.nix { lib = prev; };
  });
in {
  inherit sources pkgs lib;
}
