{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf mkDefault;
  inherit (config.services) resolved;
  c = config.sys.network.networkManager;
  wifi = config.sys.network.wireless;
in {
  options.sys.network.networkManager = {
    enable = mkEnableOption "enable network manager on the system";
  };
  
  config = mkIf c.enable {
    networking.networkmanager = {
      enable = true;
      dns = if resolved.enable then "systemd-resolved" else "none";
      wifi = mkIf (wifi.backend != "none") {
        inherit (wifi) backend;
        powersave = mkDefault true;
        scanRandMacAddress = mkDefault true;
      };
      unmanaged = [
        "interface-name:tailscale*"
        "interface-name:br-*"
        "interface-name:rndis*"
        "interface-name:docker*"
        "interface-name:virbr*"
        "interface-name:vboxnet*"
        "interface-name:waydroid*"
        "type:bridge"
      ];
    };
    
    sys.persist.scratch.directories = [
      "/var/lib/NetworkManager"
      "/etc/NetworkManager/system-connections"
    ];
  };
}
