{ lib, pkgs, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.sys.services.udisks2;
in {
  options.sys.services.udisks2 = {
    enable = mkEnableOption "enable udisks2 service config";
  };
  
  config = {
    services.udisks2.enable = c.enable;
  };
}
