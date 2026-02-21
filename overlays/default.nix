{ sources ? import ./lon.nix }:
let
  unstable-nixpkgs = final: prev: {
    unstable = import sources.nixpkgs-unstable {
      system = prev.stdenv.hostPlatform.system;
      config = prev.config;
    };
  };
  stable-nixpkgs = final: prev: {
    stable = import sources.nixpkgs-stable {
      system = prev.stdenv.hostPlatform.system;
      config = prev.config;
    };
  };
in {
  default = final: prev:
    (unstable-nixpkgs final prev) // (stable-nixpkgs final prev);
}
