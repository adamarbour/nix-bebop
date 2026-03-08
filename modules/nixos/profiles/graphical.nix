{ lib, config, ... }:
let
  inherit (lib) mkIf mkDefault;
  inherit (lib.bebop) anyHome;
  c = config.sys;
  hm = anyHome config;
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
    
    # PROGRAM DEFAULTS
    sys.programs = {
      # keep-sorted start
      kdeconnect.enable = hm (c: c.hm.services.kdeconnect.enable); # services under hm / program under nixos
      # keep-sorted end
    };
    
    # SERVICE DEFAULTS
    # hm (c: c.hm....) - this is used to enable if the home-manager configuration is enabled.
    sys.services = {
      # keep-sorted start
      xserver.enable = mkDefault true;
      xdg-portals.enable = mkDefault true;
      gvfs.enable = mkDefault true;
      gnome-keyring.enable = hm (c: c.hm.services.gnome-keyring.enable);
      gnome-settings.enable = mkDefault true;
      glib-networking.enable = mkDefault true;
      seatd.enable = mkDefault true;
      geoclue.enable = mkDefault true;
      udisks2.enable = hm (c: c.hm.services.udiskie.enable);
      tailscale.enable = mkDefault true;
      # keep-sorted end
    };
    
    # DISPLAY MANAGER
    #sys.displayManager.sddm.enable = true;
  };
}
