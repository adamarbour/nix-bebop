{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.hm.programs.tealdeer;
in {
  options.hm.programs = {
    tealdeer.enable = mkEnableOption "enable tealdeer";
  };
  
  config = mkIf (c.enable) {
    programs.tealdeer = {
      enable = true;
      settings = {
        display = {
          compact = false;
          use_pager = true;
        };
        updates = {
          auto_update = true;
          auto_update_interval_hours = 4;
        };
      };
    };
  };
}
