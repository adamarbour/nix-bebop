{
  imports = [
    ./gnome.nix
    ./hardware.nix
    (import ./disk.nix { device = "/dev/nvme0n1"; })
  ];
  sys.users = [ "adam" ];
  sys.secrets.enable = false;
  
  sys.boot = {
    efi.enable = true;
    secureBoot.enable = false;
  };
}
