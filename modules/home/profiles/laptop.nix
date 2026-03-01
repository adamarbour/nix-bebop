{ lib, config, ... }:
let
  inherit (lib) mkIf mkDefault;
  c = config.sys;
in {
  config = mkIf (c.isLaptop) {
    
  };
}
