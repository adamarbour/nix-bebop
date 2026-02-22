{ lib, pkgs, config, ...}:
let
  inherit (lib) mkEnableOption mkIf mkDefault;
  c = config.sys.hw.trackpoint;
in {
  options.sys.hw.trackpoint = {
    enable = mkEnableOption "enable trackpoint support";
  };
  
  config = mkIf (c.enable) {
    hardware.trackpoint = {
      enable = true;
      emulateWheel = mkDefault config.hardware.trackpoint.enable;
    };
  };
}
