{ lib, config, ... }:
let
  inherit (lib) mkIf;
  c = config.sys;
in {
  config = mkIf (c.isServer) {
  
  };
}
