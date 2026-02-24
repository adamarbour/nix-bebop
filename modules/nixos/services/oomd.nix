{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf mkDefault;
  c = config.sys.services.oomd;
in {
  options.sys.services.oomd = {
    enable = mkEnableOption "enable systemd-oomd service config" // { default = true; };
  };
  
  config = mkIf (c.enable) {
    systemd = {
      services.nix-daemon.serviceConfig.OOMScoreAdjust = mkDefault 350;
      services.sshd.serviceConfig.OOMScoreAdjust = mkDefault -900;
      oomd = {
        enable = mkDefault true;
        
        # Fedora enables these options by default.
        enableRootSlice = true;
        enableUserSlices = true;
        enableSystemSlice = true;
        
        settings.OOM.DefaultMemoryPressureDurationSec = "20s";
      };
    };
  };
}
