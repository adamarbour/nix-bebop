{
  imports = [
    ./gnome.nix
    ./hardware.nix
    (import ./disk.nix { device = "/dev/nvme0n1"; })
  ];
  
  sys.services.tailscale.enable = false;
  
  sys.boot = {
    efi.enable = true;
    secureBoot.enable = true;
  };
  
  sys.network.wireguard = {
    enable = true;
    address = [ "10.12.34.101/32" ];
  };
}
