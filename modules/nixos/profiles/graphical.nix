{ lib, config, ... }:
let
  inherit (lib) mkIf;
  c = config.sys;
in {
  config = mkIf (c.isGraphical) {
    sys.hw.graphics.enable = true;
    sys.hw.audio.enable = true;
  };
}
