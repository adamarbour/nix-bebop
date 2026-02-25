{ lib, pkgs, config, ...}:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.sys.hw.colord;
in {
  options.sys.hw.colord = {
    enable = mkEnableOption "enable colord service support";
  };
  
  config = mkIf (c.enable) {
    services.colord.enable = true;
    sys.persist.scratch.directories = [
      {
        directory = "/var/lib/colord";
        user = "colord";
        group = "colord";
        mode = "u=rwx,g=rx,o=";
      }
    ];
  };
}
