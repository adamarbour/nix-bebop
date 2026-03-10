{
  imports = [
    ./gnome.nix   # TEMP
    ./network.nix
    ./hardware.nix
    (import ./disk.nix { device = "/dev/nvme0n1"; })
  ];
  
  sys = {
    boot.loader = "lanzaboote";
  };
}
