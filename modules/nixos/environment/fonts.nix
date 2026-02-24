{ lib, config, ... }:
let
  inherit (lib) mkIf;
  inherit (config.sys) isGraphical;
in {
  fonts = mkIf isGraphical {
    fontconfig = {
      enable = true;
      hinting.enable = true;
      antialias = true;
    };

    # this can allow us to save some storage space
    fontDir.decompressFonts = true;
  };
}
