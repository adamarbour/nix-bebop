{ lib, config, ... }:
let
  inherit (config) sys;
  # TODO: Handle revision from git HEAD
in {
  config.system = {
    stateVersion = if (sys.class == "nixos") then "25.11" else 6;
  };
}
