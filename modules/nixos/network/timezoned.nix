{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf mkForce;
  c = config.sys.network.automatic-timezone;
in {
  options.sys.network.automatic-timezone = {
    enable = mkEnableOption "enable automatic timezone setting for the system";
  };
  
  config = mkIf (c.enable) {
    time.timeZone = mkForce null;
    services.automatic-timezoned.enable = true;
    
    # handle roaming devices better
    systemd.services.automatic-timezoned = {
      serviceConfig = {
        Type = mkForce "oneshot";
        User = "automatic-timezoned";
      };
      after = [ "network.target" ];
      wants = [ "network.target" ];
    };
    # run this as a timer instead...
    systemd.timers.automatic-timezoned = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "2m";
        OnUnitActiveSec = "15m";
        RandomizedDelaySec = "1m";
        Persistent = true;
        Unit = "automatic-timezoned.service";
      };
    };
  };
}
