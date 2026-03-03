{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.sys) isServer;
  c = config.sys.services.podman;
in {
  options.sys.services.podman = {
    enable = mkEnableOption "enable podman virtualization for system";
  };
  
  config = mkIf c.enable {
    virtualisation.containers.enable = true;
    
    # Use quadlet-nix for easy configuration...
    virtualisation.quadlet = {
      enable = true;
      autoUpdate.enable = true;
      autoUpdate.calendar = "Sun *-*-* 04:00:00";
    };
    
    sys.persist.scratch.directories = [ "/var/lib/containers" ];
    
    virtualisation.oci-containers.backend = "podman";
  };
}
