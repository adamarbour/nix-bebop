{ lib, config, ... }:
let
  inherit (lib) mkIf mkDefault;
  c = config.sys;
  prime = config.sys.h.prime;
in {
  config = mkIf (c.isGraphical) {
    # HARDWARE DEFAULTS
    sys.hw.graphics.enable = mkDefault true;
    sys.hw.audio.enable = mkDefault true;
    
    # BOOT DEFAULTS
    sys.boot.silentBoot.enable = mkDefault true;
    sys.boot.plymouth.enable = mkDefault true;
    
    # NETWORK DEFAULTS
    sys.network.optimizeTcp.enable = mkDefault true;
    
    # SERVICE DEFAULTS
    sys.services.tailscale.enable = mkDefault true;
  };
}
