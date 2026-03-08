{ lib, pkgs, config, ... }:
let
  inherit (lib) mkEnableOption mkIf mkDefault;
  c = config.sys.programs.mango;
in {
  options.sys.programs = {
    kdeconnect.enable = mkEnableOption "enable kdeconnect";
  };
  
  config = mkIf c.enable {
    programs.kdeconnect = {
      enable = true;
      package = pkgs.valent;
    };
  };
}
