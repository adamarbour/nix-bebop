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
  topology = import "${sources.nix-topology}/pkgs/default.nix";
in {
  default = final: prev:
    (topology final prev) //
    (unstable-nixpkgs final prev) // (stable-nixpkgs final prev);
}
