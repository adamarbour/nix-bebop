{ lib, pkgs, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.sys.network.wireguard;
  s = config.sys.secrets;
in {
  options.sys.network.wireguard = {
    enable = mkEnableOption "enable wireguard support" // { default = true; };
  };
  
  config = mkIf (c.enable) {
    boot.kernelModules = [ "wireguard" ];
    environment.systemPackages = [ pkgs.wireguard-tools ];
    
    sops.secrets = mkIf s.enable {
      "host/wg.key" = {
        sopsFile = s.hostSopsFile;
        key = "wg/key";
      };
      "host/wg.pub" = {
        sopsFile = s.hostSopsFile;
        key = "wg/pub";
      };
    };
  };
}
