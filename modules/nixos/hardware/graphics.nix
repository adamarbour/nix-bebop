{ lib, pkgs, config, ...}:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.sys.hw.graphics;
in {
  options.sys.hw.graphics = {
    enable = mkEnableOption "enable graphics support";
  };
  
  config = mkIf (c.enable) {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
