{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.sys.programs.pay-respects;
in {
  options.sys.programs = {
    pay-respects.enable = mkEnableOption "enable pay-respects" // { default = true; };
  };
  
  config = mkIf c.enable {
    programs.pay-respects = {
      enable = true;
      alias = "f";
    };
  };
}
