{ lib, pkgs, ... }:
let
  inherit (lib) mkDefault;
in {
  config = {
    services.journald = {
      storage = "persistent";
      extraConfig = ''
          SystemMaxUse=100M
          SystemMaxFileSize=10M
          SystemMaxFiles=10
          RuntimeMaxUse=50M
          RuntimeMaxFileSize=10M
          MaxRetentionSec=1month
          RateLimitIntervalSec=30s
          RateLimitBurst=1000
          Compress=yes
          Seal=yes
          ForwardToSyslog=no
          ForwardToConsole=no
          ForwardToWall=no
          SyncIntervalSec=5m
          MaxLevelStore=info
        '';
    };
  };
}
