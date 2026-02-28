{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf mkForce;
  c = config.sys.network.automatic-timezone;
in {
  options.sys.network.automatic-timezone = {
    enable = mkEnableOption "enable automatic timezone setting for the system";
  };
  
  config = mkIf (c.enable) {
    time.timeZone = mkForce null;
    services.automatic-timezoned.enable = true;
    
    # https://github.com/NixOS/nixpkgs/issues/68489#issuecomment-1484030107
    services.geoclue2.enableDemoAgent = mkForce true;
  };
}
