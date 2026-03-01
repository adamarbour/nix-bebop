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
      permitCertUid = config.sys.primaryUser;
      useRoutingFeatures = if c.makeExitNode then "server" else "client";
      
      extraSetFlags = [
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
