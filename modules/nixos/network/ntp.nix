{ lib, ... }:
let
  inherit (lib) mkForce;
in {
  config = {
    networking.timeServers = [
      "time.nist.gov"
      "time-a.nist.gov"
      "time-b.nist.gov"
      "time-c.nist.gov"
    ];
    services.ntpd-rs = {
      enable = true;
      useNetworkingTimeServers = true;
      settings.observability.log-level = "warn";
    };
    services.ntp.enable = mkForce false;
    services.timesyncd.enable = mkForce false;
    services.openntpd.enable = mkForce false;
    services.chrony.enable = mkForce false;
  };
}
