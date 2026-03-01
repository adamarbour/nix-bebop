{ lib, pkgs, config, ... }:
let
  inherit (lib) types mkOption mkEnableOption mkIf;
  c = config.sys.network.wireguard;
  s = config.sys.secrets;
in {
  options.sys.network.wireguard = {
    enable = mkEnableOption "enable wireguard";
    role = mkOption {
      type = types.enum [ "client" "hub" ];
      default = "client";
      description = "client dials a hub; hub accepts spokes and routes between them.";
    };
    
    interface = mkOption {
      type = types.str;
      default = "wg0";
    };
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
    networking.firewall.allowedUDPPorts = lib.optional (c.listenPort != null) c.listenPort;
    
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
    
    networking.wg-quick.interfaces."${c.interface}" = {
      inherit (c) address listenPort;
      privateKeyFile = mkIf (s.enable) config.sops.secrets."host/wg.key".path;
    };
  };
}
