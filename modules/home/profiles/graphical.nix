{ lib, config, ... }:
let
  inherit (lib) mkIf mkDefault;
  c = config.sys;
in {
  config = mkIf (c.isGraphical) {
    # sane services
    hm.services.udiskie.enable = mkDefault true;
    
    # sane programs
  };
}
