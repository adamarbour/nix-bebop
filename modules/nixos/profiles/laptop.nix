{ lib, config, ... }:
let
  inherit (lib) mkIf;
  c = config.sys;
in {
  config = mkIf (c.isLaptop) {
    sys.hw.brillo.enable = true;
    sys.hw.trackpad.enable = true;
  };
}
