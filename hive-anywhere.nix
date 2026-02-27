{ sources ? import ./lon.nix }:
let
  root = import ./default.nix {};
  inherit (root) lib nodes;
in lib.mapAttrs (_name: node: {
  nixos-system = value.config.system.build.toplevel;
  disko-script = value.config.system.build.diskoScriptNoDeps;
}) nodes
