{ lib, pkgs, config, ...}:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.sys.hw.brillo;
in {
  options.sys.hw.brillo = {
    enable = mkEnableOption "enable brillo (brightness) support";
  };
  
  config = mkIf (c.enable) {
    hardware.brillo.enable = true;
  };
}
