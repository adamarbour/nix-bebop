{ lib, pkgs, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.hm.services.kdeconnect;
in {
  options.hm.services.kdeconnect = {
    enable = mkEnableOption "enable kdeconnect (gtk) service";
  };
  
  config = mkIf (c.enable) {
    services.kdeconnect = {
      enable = true;
      package = pkgs.valent;
    };
  };
}
