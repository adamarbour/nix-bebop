{ sources ? import ../lon.nix }:
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
  cachyos-kernel = final: prev:
    let
      compat = import sources.nix-cachyos-kernel;
    in compat.overlays.pinned final prev;
in {
  default = final: prev:
    (topology final prev) //
    (cachyos-kernel final prev) //
    (unstable-nixpkgs final prev) // (stable-nixpkgs final prev);
}
