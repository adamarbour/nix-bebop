{ lib, config, sources, ... }:
let
  mangoCompat = (import sources.flake-compat { src = sources.mango; }).defaultNix;
  inherit (lib) mkEnableOption mkIf mkDefault;
  c = config.sys.programs.mango;
in {
  imports = [ mangoCompat.nixosModules.mango ];
  
  options.sys.programs = {
    mango.enable = mkEnableOption "enable mangowm (Wayland)";
  };
  
  config = mkIf c.enable {
    programs.mango.enable = true;
  };
}
