{
  imports = [
    ./network.nix
    ./disk.nix
  ];
  
  sys = {
    hw.cpu = "intel";
    boot.loader = "systemd";
  };
}
