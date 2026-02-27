{ lib, ... }:
let
  inherit (lib) mkForce;
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
}
