{ sources ? import ./lon.nix }:
let
  root = import ./default.nix { inherit sources; };
  inherit (root) lib;
  nodes = root.evaluatedHive.nodes;
in lib.mapAttrs (_name: node: {
  nixos-system = node.config.system.build.toplevel;
  disko-script = node.config.system.build.diskoScriptNoDeps;
}) nodes
