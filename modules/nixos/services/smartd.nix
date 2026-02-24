{ lib, pkgs, config, ... }:
let
  inherit (lib) mkEnableOption mkIf mkDefault;
  c = config.sys.services.smartd;
in {
  options.sys.services.smartd = {
    enable = mkEnableOption "enable smartd service config";
  };
  
  config = mkIf (c.enable) {
    services.smartd = {
      enable = true;
      extraOptions = [ "--interval=1800" ];
      defaults.monitored = "-a -o on -n standby,q -s (S/../.././02|L/../../7/04)";
      autodetect = true;
      notifications.mail.enable = mkDefault false;
    };
  };
}
