{ ... }:
{
  networks.backplane = {
    name = "wireguard";
    style.pattern = "dotted";
    cidrv4 = "10.12.34.0/24";
  };
  networks.tailscale = {
    name = "tailscale";
    style.pattern = "dashed";
    cidrv4 = "100.0.0.0/8";
  };
  networks.lab = {
    name = "homelab";
    style.pattern = "solid";
    cidrv4 = "172.31.0.0/16";
  };
}
