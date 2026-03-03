{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.sys) isServer;
  c = config.sys.podman;
in {
  options.sys.podman = {
    enable = mkEnableOption "enable podman virtualization for system";
  };
  
  config = mkIf c.enbale {
    virtualisation.containers.enable = true;
    virtualisation.podman = {
      enable = true;
      dockerCompat = mkDefault true;
      defaultNetwork.settings.dns_enabled = true;
    };
    
    sys.persist.scratch.directorys = [ "/var/lib/containers" ];
    
    virtualisation.oci-containers.backend = "podman";
  };
}
