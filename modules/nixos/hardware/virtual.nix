{ lib, pkgs, config, ...}:
let
  inherit (lib) mkEnableOption mkIf mkForce;
  c = config.sys.hw.virtual;
in {
  options.sys.hw.virtual = {
    enable = mkEnableOption "enable qemu guest support";
  };
  
  config = mkIf (c.enable) {
    boot.initrd.availableKernelModules = [
      "virtio_pci"
      "virtio_blk"
      "virtio_scsi"
      "virtio_net"
      "virtio_balloon"
      "virtio_rng"
    ];
    services = {
      smartd.enable = mkForce false;
      thermald.enable = mkForce false;
      fwupd.enable = mkForce false;
      
      qemuGuest.enable = true;
    };
    systemd.services.qemu-guest-agent.path = [ pkgs.shadow ];
    
    hardware.bluetooth.enable = mkForce false;
  };
}
