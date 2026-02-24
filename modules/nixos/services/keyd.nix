{ lib, pkgs, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.sys.services.keyd;
in {
  options.sys.services.keyd = {
    enable = mkEnableOption "enable keyd service config" // { default = true; };
  };
  
  config = mkIf (c.enable) {
    services.keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = [ "*" ];
          settings.main.capslock = "overload(control, esc)";
        };
      };
    };
  };
}
