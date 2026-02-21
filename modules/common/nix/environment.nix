{ lib, ... }:
let
  inherit (lib) mkForce;
in {
  # https://github.com/NixOS/nixpkgs/blob/fe96650ccf51fcda83e4df82b321774f9c4eb041/nixos/modules/programs/environment.nix#L18
  # unsetting...
  environment.variables.NIXPKGS_CONFIG = mkForce "";
}
