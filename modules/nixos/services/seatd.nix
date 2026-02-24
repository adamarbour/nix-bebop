{ lib, config, ...}:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.sys.services.seatd;
in {
  options.sys.services.seatd = {
    enable = mkEnableOption "enable the seatd service config";
  };
  
  config = mkIf (c.enable) {
    services.seatd.enable = true;
  };
}
