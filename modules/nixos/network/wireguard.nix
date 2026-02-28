{ lib, pkgs, config, ... }:
let
  inherit (lib) types mkOption mkEnableOption mkIf;
  c = config.sys.network.wireguard;
  s = config.sys.secrets;
in {
  options.sys.network.wireguard = {
    enable = mkEnableOption "enable wireguard";
    
    address = mkOption {
      type = types.listOf types.str;
      example = [ "10.44.0.2/32" ];
    };
    
    listenPort = mkOption {
      type = types.nullOr types.port;
      default = 51820;
    };
  };
  
  config = mkIf c.enable {
    boot.kernelModules = [ "wireguard" ];
    environment.systemPackages = [ pkgs.wireguard-tools ];
    networking.firewall.allowedUDPPorts = [ c.listenPort ];
    
    # expect wg from host secrets
    sops.secrets = mkIf (s.enable) {
      "host/wg.key" = {
        sopsFile = s.hostSopsFile;
        key = "wg/key";
      };
      "host/wg.pub" = {
        sopsFile = s.hostSopsFile;
        key = "wg/pub";
      };
    };
    
    networking.wg-quick.interfaces.wg0 = {
      inherit (c) address;
      inherit (c) listenPort;
      privateKeyFile = mkIf (s.enable) config.sops.secrets."host/wg.key".path;
    };
  };
}
