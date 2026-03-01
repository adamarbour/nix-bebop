{ lib, config, ... }:
let
  inherit (lib) mkIf;
  s = config.sys.secrets;
in {
  # Setup backplane wireguard for deployment and communication...
  networking.firewall.trustedInterfaces = [ "wg0" ];
  networking.wg-quick.interfaces.wg0 = {
    address = [ "10.12.34.101/32" ];
    privateKeyFile = mkIf (s.enable) config.sops.secrets."host/wg.key".path;
    peers = [{
      # arbourcloud
      publicKey = "hP4t588uCk673XQf4jtMV9w04Coyl0haJ4Xwuxi1Vjw=";
      allowedIPs = [ "10.12.34.0/24" ];
      endpoint = "wg0.arbour.cloud:51820";
      persistentKeepalive = 25;
    }];
  };
}
