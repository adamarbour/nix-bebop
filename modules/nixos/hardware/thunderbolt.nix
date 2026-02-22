{ lib, pkgs, config, ...}:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.sys.hw.thunderbolt;
in {
  options.sys.hw.thunderbolt = {
    enable = mkEnableOption "enable thunderbolt support";
  };
  
  config = mkIf (c.enable) {
    services.hardware.bolt.enable = true;
    services.udev.packages = [ pkgs.bolt ];
    services.logind.settings.Login = {
      HandleLidSwitchDocked = "ignore";
    };
    boot = {
      initrd.availableKernelModules = [ "thunderbolt" ];
    };
  };
}
