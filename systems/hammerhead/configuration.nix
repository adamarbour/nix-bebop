{
  imports = [
    ./network.nix
    (import ./disk.nix { device = "/dev/vda"; })
  ];
  
  sys.services.tailscale.enable = false;
  
  sys.boot = {
    efi.enable = false;
    bios.device = "/dev/vda";
  };
  sys.hw.virtual.enable = true;
}
