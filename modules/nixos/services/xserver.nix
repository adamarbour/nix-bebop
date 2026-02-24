{ lib, pkgs, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.sys.services.xserver;
in {
  options.sys.services.xserver = {
    enable = mkEnableOption "enable xserver service config";
  };
  
  config = mkIf (c.enable) {
    services.xserver = {
      enable = true;
      desktopManager.xterm.enable = false;
      excludePackages = [ pkgs.xterm ];
    };
  };
}
