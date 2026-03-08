{ lib, config, ... }:
let
  inherit (lib) mkForce mkIf;
  s = config.sys.secrets;
in {
  sys.network.optimizeTcp.enable = true;
  # Enable wifi
  sys.network.wireless.backend = "iwd";
  # Onboard NIC uses DHCP...
  networking.interfaces.enp5s0.useDHCP = true;
  
  # Setup backplane wireguard for deployment and communication...
  networking.firewall.trustedInterfaces = [ "wg0" ];
  networking.wg-quick.interfaces.wg0 = {
    address = [ "10.12.34.71/32" ];
    privateKeyFile = mkIf (s.enable) config.sops.secrets."host/wg.key".path;
    peers = [{
      # arbourcloud
      publicKey = "hP4t588uCk673XQf4jtMV9w04Coyl0haJ4Xwuxi1Vjw=";
      allowedIPs = [ "10.12.34.0/24" ];
      endpoint = "wg0.arbour.cloud:51820";
      persistentKeepalive = 25;
    }];
  };
  systemd.services."wg-quick-wg0" = {
    wants = [ "network.target" "nss-lookup.target" ];
    after = [ "network.target" "nss-lookup.target" ];
  };
}
