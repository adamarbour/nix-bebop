{ lib, config, ... }:
let
  inherit (lib) mkIf mkDefault;
  c = config.sys;
  prime = config.sys.hw.prime;
in {
  config = mkIf (c.isLaptop) {
    # HARDWARE DEFAULTS
    sys.hw.brillo.enable = mkDefault true;
    sys.hw.trackpad.enable = mkDefault true;
    sys.hw.thunderbolt.enable = mkDefault true;
    
    # PRIME (nvidia) DEFAULTS
    sys.hw.prime = mkIf (prime.enable) {
      dynamicBoost = mkDefault true;
      finegrainedPM = mkDefault true;
    };
  };
}
