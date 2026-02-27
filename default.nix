{ sources ? import ./lon.nix, system ? builtins.currentSystem }:
let
  overlays = import ./overlays { inherit sources; };
  pkgs = import sources.nixpkgs {
    localSystem = { inherit system; };
    overlays = [ overlays.default ];
  };
  lib = pkgs.lib.extend ( final: prev: {
    bebop = import ./lib/bebop.nix { lib = prev; };
  });
  
  # colmena
  rawHive = import ./hive.nix { inherit sources; };
  evaluatedHive = import "${sources.colmena}/src/nix/hive/eval.nix" {
    inherit rawHive;
    colmenaOptions = import "${sources.colmena}/src/nix/hive/options.nix";
    colmenaModules = import "${sources.colmena}/src/nix/hive/modules.nix";
  };
  nodes = evaluatedHive.nodes;
  nixosConfigurations = lib.mapAttrs (_: node: node) nodes;
  toplevel = lib.mapAttrs (_: node: node.config.system.build.toplevel) nodes;
  
  # nix-topology
  nix-topology = import sources.nix-topology {
    inherit pkgs;
    modules = [
      ./topology.nix
      { inherit nixosConfigurations; }
    ];
  };
in {
  inherit sources pkgs lib;
  
  # hive exposure
  inherit rawHive evaluatedHive nodes;
  inherit nixosConfigurations toplevel;
  
  # for building topology layout
  topology = nix-topology.config.output;
}
