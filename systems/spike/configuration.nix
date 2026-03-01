{
  imports = [
    ./gnome.nix
    ./network.nix
    ./hardware.nix
    (import ./disk.nix { device = "/dev/nvme0n1"; })
  ];
  
  sys.boot = {
    efi.enable = true;
    secureBoot.enable = true;
  };
}
