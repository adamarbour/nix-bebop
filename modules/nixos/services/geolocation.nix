{ lib, config, ...}:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.sys.services.geoclue;
in {
  options.sys.services.geoclue = {
    enable = mkEnableOption "enable the geolocation (geoclue) config";
  };
  
  config = mkIf (c.enable) {
    location.provider = "geoclue2";
    
    services.geoclue2 = {
      # enable geoclue2 only if location.provider is geoclue2
      enable = config.location.provider == "geoclue2";
      
      # gammastep
      appConfig.gammastep = {
        isAllowed = true;
        isSystem = false;
      };
    };
  };
}
