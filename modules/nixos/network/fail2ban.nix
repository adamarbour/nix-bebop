{ lib, config, ... }:
let
  inherit (lib) mkMerge mkEnableOption mkIf mkForce;
  c = config.sys.services.fail2ban;
in {
  options.sys.services.fail2ban = {
    enable = mkEnableOption "enable fail2ban services";
  };
  
  config = mkIf (c.enable) {
    services.fail2ban = {
      enable = true;
      maxretry = 5;
      bantime = "1h";
      ignoreIP = [
        "127.0.0.0/8"
        "10.0.0.0/8"
        "192.168.0.0/16"
        "172.31.0.0/16"
        "100.0.0.0/8" # tailscale
      ];
      jails = mkMerge [
        {
          sshd = mkForce ''
            enabled = true
            port = ${lib.concatStringsSep "," (map toString config.services.openssh.ports)}
          '';
        }
      ];
      bantime-increment = {
        enable = true;
        rndtime = "7m";
        factor = "2";
        maxtime = "7d";
        overalljails = true; # Calculate the bantime based on all the violations
      };
    };
  };
}
