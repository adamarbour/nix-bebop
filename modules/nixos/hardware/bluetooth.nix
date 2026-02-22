{ lib, pkgs, config, ...}:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.sys.hw.bluetooth;
in {
  options.sys.hw.bluetooth = {
    enable = mkEnableOption "enable bluetooth support";
  };
  
  config = mkIf (c.enable) {
    boot.kernelModules = [ "btusb" ];
    services.blueman.enable = true;
    
    hardware.bluetooth = {
      enable = true;
      disabledPlugins = [ "sap" ];
      settings = {
        General = {
          ControllerMode = "dual";
          FastConnectable = true;
          JustWorksRepairing = "always";
          MultiProfile = "multiple";
          Privacy = "device";
          PairableTimeout = 30;
          DiscoverableTimeout = 30;
          TemporaryTimeout = 0;
        };
        Policy = {
          ReconnectIntervals = "1,1,2,3,5,8,13,21,34,55";
          AutoEnable = true;
          Privacy = "network/on";
        };
        LE = {
          MinConnectionInterval = "7";
          MaxConnectionInterval = "9";
          ConnectionLatency = "0";
        };
      };
    };
  };
}
