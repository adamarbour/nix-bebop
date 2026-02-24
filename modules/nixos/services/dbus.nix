{ lib, pkgs, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.sys.services.dbus;
in {
  options.sys.services.dbus = {
    enable = mkEnableOption "enable dbus broker service config" // { default = true; };
  };
  
  config = mkIf (c.enable) {
    services.dbus.implementation = "broker";
  };
}
