{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.hm.services.udiskie;
in {
  options.hm.services.udiskie = {
    enable = mkEnableOption "enable udiskie service";
  };
  
  config = mkIf (c.enable) {
    services.udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "auto"; # auto, always, never
    };
  };
}
