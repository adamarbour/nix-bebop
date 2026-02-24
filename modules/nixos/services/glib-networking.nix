{ lib, pkgs, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.sys.services.glib-networking;
in {
  options.sys.services.glib-networking = {
    enable = mkEnableOption "enable glib-networking service config";
  };
  
  config = {
    services.gnome.glib-networking.enable = c.enable;
  };
}
