{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.sys.boot.plymouth;
in {
  options.sys.boot.plymouth = {
    enable = mkEnableOption "enable plymouth";
  };
  
  config = mkIf (c.enable) {
    # enable silent boot
    sys.boot.silentBoot.enable = true;
    
    boot.plymouth = {
      enable = true;
    };
  };
}
