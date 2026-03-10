{ lib, config, ... }:
let
  inherit (lib) optionals mkEnableOption mkIf mkDefault;
  inherit (config.sys) isServer;
  inherit (config.services) tailscale;
  c = config.sys.services.tailscale;
in {
  options.sys.services.tailscale = {
    enable = mkEnableOption "enable tailscale service";
    makeExitNode = mkEnableOption "enable system to be tailscale exit node";
  };
  
  config = mkIf (c.enable) {
    networking.firewall = {
      trustedInterfaces = [ "${tailscale.interfaceName}" ];
      allowedUDPPorts = mkIf isServer [ tailscale.port ];
    };
    
    sys.persist.storage.directories = [ "/var/lib/tailscale" ];
    
    services.tailscale = {
      enable = true;
      
      # Hand this off to caddy if enabled
      permitCertUid = if config.services.caddy.enable then config.services.caddy.user
        else config.sys.primaryUser;
      useRoutingFeatures = if c.makeExitNode then "server" else "client";
      
      extraSetFlags = [
        "--accept-dns" "--accept-routes"
      ] ++ optionals c.makeExitNode [
        "--advertise-exit-node"
      ];
      
      disableUpstreamLogging = mkDefault true;
    };
    
    systemd.services.tailscaled.serviceConfig.Environment = [ 
      "TS_DEBUG_FIREWALL_MODE=nftables" 
    ];
  };
}
