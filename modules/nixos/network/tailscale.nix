{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.sys) isServer;
  inherit (config.services) tailscale;
  c = config.sys.services.tailscale;
in {
  options.sys.services.tailscale = {
    enable = mkEnableOption "enable tailscale service";
  };
  
  config = mkIf (c.enable) {
    networking.firewall = {
      trustedInterfaces = [ "${tailscale.interfaceName}" ];
      allowedUDPPorts = [ tailscale.port ];
    };
    
    sys.persist.storage.directories = [ "/var/lib/tailscale" ];
    
    services.tailscale = {
      enable = true;
      useRoutingFeatures = if isServer then "server" else "client";
      extraSetFlags = [ "--auto-upgrade=false" ];
      extraDaemonFlags = [ "--no-logs-no-support" ];
    };
  };
}
