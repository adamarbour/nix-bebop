{ lib, pkgs, config, ...}:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.sys.hw.fprint;
in {
  options.sys.hw.fprint = {
    enable = mkEnableOption "enable fprint support";
  };
  
  config = mkIf (c.enable) {

  };
}
