{ lib, config, ... }:
let
  inherit (lib) mkIf mkDefault;
  c = config.sys;
  prime = config.sys.h.prime;
in {
  config = mkIf (c.isDesktop) {

  };
}
