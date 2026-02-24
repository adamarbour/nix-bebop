{ lib, config, ... }:
let
  inherit (lib) mkDefault mkForce;
  inherit (config.sys) isServer;
in {
  config = {
    networking.nftables = {
      enable = mkDefault true;
    };
    networking.firewall = {
      enable = true;

      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];

      allowedTCPPortRanges = [ ];
      allowedUDPPortRanges = [ ];
      
      allowPing = if (isServer) then true else false;
      pingLimit = "1/minute burst 5 packets";
      
      logReversePathDrops = true;
      logRefusedConnections = false;
      
      checkReversePath = mkForce false;
    };
  };
}
