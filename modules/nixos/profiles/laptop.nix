{ lib, config, ... }:
let
  inherit (lib) mkIf mkDefault;
  c = config.sys;
  prime = config.sys.hw.prime;
in {
  config = mkIf (c.isLaptop) {
    # NETWORK DEFAULTS
    sys.network.networkManager.enable = mkDefault true;
    sys.network.wireless.backend = mkDefault "iwd";
    sys.network.automatic-timezone.enable = mkDefault true;
    
    # HARDWARE DEFAULTS
    sys.hw.brillo.enable = mkDefault true;
    sys.hw.trackpad.enable = mkDefault true;
    sys.hw.thunderbolt.enable = mkDefault true;
    sys.hw.bluetooth.enable = mkDefault true;
    sys.hw.tpm.enable = mkDefault true;
    
    # PRIME (nvidia) DEFAULTS
    sys.hw.prime = mkIf (prime.enable) {
      dynamicBoost = mkDefault true;
      finegrainedPM = mkDefault true;
    };
    
    # MISC
    # save backlight status between reboots
    sys.persist.scratch.directories = [ "/var/lib/systemd/backlight" ];
  };
}
