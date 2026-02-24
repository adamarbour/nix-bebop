{ lib, config, ... }:
let
  inherit (lib) mkIf mkDefault;
  c = config.sys;
in {
  config = mkIf (c.isServer) {
    # NETWORK DEFAULTS
    sys.network.networkd.enable = mkDefault true;
    
    # SERVICE DEFAULTS
    sys.services.tailscale.enable = mkDefault true;
  };
}
