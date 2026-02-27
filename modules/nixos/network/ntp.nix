{ lib, ... }:
let
  inherit (lib) mkForce;
in {
  config = {
    networking.timeServers = [
      "0.pool.ntp.org"
      "1.pool.ntp.org"
      "2.pool.ntp.org"
      "3.pool.ntp.org"
    ];
    services.ntpd-rs = {
      enable = true;
      useNetworkingTimeServers = true;
      settings.observability.log-level = "warn";
      settings.synchronization.algorithm.step-threshold = 10.0;
    };
    services.ntp.enable = mkForce false;
    services.timesyncd.enable = mkForce false;
    services.openntpd.enable = mkForce false;
    services.chrony.enable = mkForce false;
  };
}
