{ lib, pkgs, config, ...}:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.sys.hw.i2c;
in {
  options.sys.hw.i2c = {
    enable = mkEnableOption "enable i2c/ddcci support";
  };
  
  config = mkIf (c.enable) {
    boot.extraModulePackages = with config.boot.kernelPackages; [ ddcci-driver ];
    boot.initrd.availableKernelModules = [ "ddcci-backlight" ];
    
    environment.systemPackages = with pkgs; [
      ddccontrol ddccontrol-db
    ];
    
    hardware.i2c.enable = true;
  };
}
