{ lib, pkgs, config, ...}:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.sys.hw.i2c;
in {
  options.sys.hw.i2c = {
    enable = mkEnableOption "enable i2c support";
  };
  
  config = mkIf (c.enable) {
    hardware.i2c.enable = true;
  };
}
