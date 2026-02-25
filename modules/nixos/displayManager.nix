{ lib, pkgs, config, ... }:
let
  inherit (lib) mkMerge mkEnableOption mkIf;
  c = config.sys.displayManager;
in {
  options.sys.displayManager = {
    sddm.enable = mkEnableOption "use the sddm display manager";
  };
  
  config = mkMerge [
    # SDDM
    (mkIf (c.sddm.enable) {
      services.displayManager.enable = true;
      services.displayManager.sddm = {
        enable = true;
      };
      
      sys.persist.scratch.directories = [
        {
          directory = "/var/lib/sddm";
          user = "sddm";
          group = "sddm";
          mode = 755;
        }
      ];
    })
  ];
}
