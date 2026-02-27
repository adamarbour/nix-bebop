{ lib, config, ... }:
let
  inherit (lib) mkIf mkDefault;
  c = config.sys;
in {
  config = mkIf (c.isServer) {
    # DISABLE HOME MANAGER
    hm.enable = mkDefault false;
    
    # NETWORK DEFAULTS
    sys.network.networkd.enable = mkDefault true;
    sys.services.fail2ban.enable = mkDefault true;
    
    # SERVICE DEFAULTS
    sys.services.smartd.enable = mkDefault true;
    sys.services.tailscale.enable = mkDefault true;
    
    # SERVER SPECIFIC
    sys.security.auditd.enable = mkDefault true;
  };
}
