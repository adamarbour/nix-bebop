{ sources ? import ./lon.nix }:
let
  unstable-nixpkgs = final: prev: {
    unstable = import sources.nixpkgs-unstable {
      localSystem = { system = prev.stdenv.hostPlatform.system; };
      config = prev.config;
      overlays = prev.overlays or [ ];
    };
  };
  stable-nixpkgs = final: prev: {
    stable = import sources.nixpkgs-stable {
      localSystem = { system = prev.stdenv.hostPlatform.system; };
      config = prev.config;
      overlays = prev.overlays or [ ];
    };
  };
  topology = import "${sources.nix-topology}/pkgs/default.nix";
in {
  default = final: prev:
    (topology final prev) //
    (unstable-nixpkgs final prev) // (stable-nixpkgs final prev);
}
