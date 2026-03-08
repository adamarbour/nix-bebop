{ lib, config, ... }:
let
  inherit (lib) mkForce mkIf;
  s = config.sys.secrets;
in {
  networking.enableIPv6 = mkForce false;
  
  systemd.network.networks."10-eth0" = {
    matchConfig.Name = "enp0s3";
    addresses = [
      { Address = "172.245.210.47/24"; }
    ];
    routes = [
      { Gateway = "172.245.210.1"; }
    ];
  };
  
  # Setup backplane wireguard for deployment and communication...
  networking.firewall.allowedUDPPorts = [ 51820 ];
  networking.firewall.trustedInterfaces = [ "wg0" ];
  networking.wg-quick.interfaces.wg0 = {
    listenPort = 51820;
    address = [ "10.12.34.56/32" ];
    privateKeyFile = mkIf (s.enable) config.sops.secrets."host/wg.key".path;
    peers = [
      # bebop
      { allowedIPs = [ "10.12.34.101/32" ]; publicKey = "RVe2Mg8JvhC5MTdnppTLP3KhGRgIqWYrN+IdjXbYZxk="; } # spike
      # 9realms
      { allowedIPs = [ "10.12.34.71/32" ]; publicKey = "QACug4nJsvGmGaY46DM0OS95Dl6KHGnYo1ki0ghiFEc="; } # asgard
    ];
  };
  
  # Handle podman networks.
  virtualisation.quadlet.networks = {
    local.networkConfig.subnets = [ "10.0.9.1/24" ];
    external.networkConfig.subnets = [ "10.0.10.1/24" ];
  };
}
