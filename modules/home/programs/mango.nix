{ lib, config, sources, ... }:
let
  mangoCompat = (import sources.flake-compat { src = sources.mango; }).defaultNix;
  inherit (lib) mkEnableOption mkIf;
  c = config.hm.programs.mango;
in {
  imports = [ mangoCompat.hmModules.mango ];
  
  options.hm.programs = {
    mango.enable = mkEnableOption "enable mango window manager (Wayland)";
  };
  
  config = mkIf (c.enable) {
    wayland.windowManager.mango = {
      enable = true;
    };
  };
}
