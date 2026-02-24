{ lib, pkgs, config, ... }:
let
  inherit (lib) getExe mkEnableOption mkIf mkDefault;
  c = config.sys.services.xdg-portals;
in {
  options.sys.services.xdg-portals = {
    enable = mkEnableOption "enable baseline xdg-portal service config";
  };
  
  config = mkIf (c.enable) {
    xdg.portal = {
      enable = mkDefault true;
      xdgOpenUsePortal = mkDefault true;
      wlr.enable = true;
      wlr.settings = {
        screencast = {
          max_fps = 60;
          chooser_type = "simple";
          chooser_cmd = "${getExe pkgs.slurp} -f %o -or";
        };
      };
      
      config = {
        common.default = [ "gtk" ];
        common."org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };
    };
  };
}
