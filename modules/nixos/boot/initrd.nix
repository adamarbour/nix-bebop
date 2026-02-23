{ lib, config, ... }:
let
  inherit (lib) optionals mkDefault;
  hasBtrfs = (lib.filterAttrs (_: v: v.fsType == "btrfs") config.fileSystems) != { };
in {
  config = {
    boot.consoleLogLevel = 3;
    # we don't use this
    boot.swraid.enable = mkDefault false;
    # increase map count for apps that require lots of memory pages
    boot. kernel.sysctl."vm.max_map_count" = 2147483642;
    
    boot.initrd = {
      systemd.enable = (!config.boot.swraid.enable && !config.boot.isContainer);
      verbose = false;
      
      kernelModules = [
        "dm_mod"
        "dm_crypt"
      ] ++ optionals hasBtrfs [
        "btrfs"
      ];
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "usbhid"
        "dm_mod"
        "dm_crypt"
        "ext4"
        "btrfs"
      ];
    };
  };
}
