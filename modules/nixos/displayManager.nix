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
      
      systemd.tmpfiles.rules = [
        "d /var/lib/sddm 0755 sddm sddm"
        "d /var/lib/sddm/.config 0755 sddm sddm"
        "d /var/lib/sddm/.config/hypr 0755 sddm sddm"
      ];
      
      sys.scratch.directories = [ "/var/lib/sddm" ];
    })
  ];
}
