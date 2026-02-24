{ lib, pkgs, config, ... }:
let
  inherit (lib) mkEnableOption mkIf mkForce;
  c = config.sys.services.gnome-settings;
in {
  options.sys.services.gnome-settings = {
    enable = mkEnableOption "enable gnome-settings service config";
  };
  
  config = mkIf (c.enable) {
    services.gnome.gnome-settings-daemon.enable = true;
    services.gnome.gnome-remote-desktop.enable = mkForce false;
    programs.dconf.enable = true;
  };
}
