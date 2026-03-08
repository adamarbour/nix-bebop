{ config, ... }:
{
  # Persist volume
  sys.persist.scratch.directories = [ "/var/lib/uptime-kuma" ];
  
  services.caddy.enable = false; #TODO: factor this out...
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  
  services.caddy.virtualHosts = {
    "status.arbour.cloud".extraConfig = ''
      reverse_proxy localhost:3001
    '';
  };
  
  virtualisation.quadlet = let
    inherit (config.virtualisation.quadlet) networks pods;
  in {
    containers.uptime-kuma = {
      autoStart = true;
      containerConfig = {
        image = "docker.io/louislam/uptime-kuma:2";
        name = "uptime";
        volumes = [
          "/var/lib/uptime-kuma:/app/data"
        ];
        networks = [ networks.external.ref ];
        publishPorts = [ "3001:3001" ];
        pod = pods.infra.ref;
        pull = "always";
        
        # Handle health - TODO: Pass in pkgs?
      };
      serviceConfig = {
        Restart = "always";
        StopTimeout = "30";
      };
    };
  };
}
