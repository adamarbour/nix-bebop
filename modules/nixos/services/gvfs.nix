{ lib, pkgs, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.sys.services.gvfs;
in {
  options.sys.services.gvfs = {
    enable = mkEnableOption "enable gvfs service config";
  };
  
  config = {
    services.gvfs.enable = c.enable;
  };
}
