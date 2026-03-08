{
  imports = [
    ./network.nix
    ./uptime-kuma.nix
    (import ./disk.nix { device = "/dev/vda"; })
  ];
  
  sys.boot = {
    loader = "grub";
    efi.enable = false;
    bios.device = "/dev/vda";
  };
  sys.hw.virtual.enable = true;
  sys.services = {
    podman.enable = true;
  };
  
  virtualisation.quadlet = {
    pods = {
      infra = {};
    };
  };
}
