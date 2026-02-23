{ lib, config, ... }:
let
  inherit (lib) mkIf;
  c = config.sys;
  prime = config.sys.h.prime;
in {
  config = mkIf (c.isGraphical) {
    sys.hw.graphics.enable = true;
    sys.hw.audio.enable = true;
  };
}
