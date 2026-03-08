{ ... }:
let
  # Local storage for systems with parity
  nas1 = "/dev/disk/by-id/wwn-0x5000c500c2f81291";
  nas2 = "/dev/disk/by-id/wwn-0x5000c500e9e1eb7c";
  nas3 = "/dev/disk/by-id/wwn-0x5000c500c71ee8f4";
  # Podman containers for nflix...
  nflix = "/dev/disk/by-id/ata-SPCC_M.2_SSD_GDFCPBAS5JZKN8VXNNOD";
  # Storage to support incus
  ceph1 = "/dev/disk/by-id/ata-ORICO_UB202411211005";
  ceph2 = "/dev/disk/by-id/ata-ORICO_UB202411212429";
  ceph3 = "/dev/disk/by-id/ata-ORICO_UB202411212151";
  ceph4 = "/dev/disk/by-id/ata-ORICO_UB202411211002";
in {
  disko.devices.nodev."/" = {
    fsType = "tmpfs";
    mountOptions = [ "defaults" "size=512M" "mode=755" ];
  };
  
  # Primary OS
  disko.devices.disk.disk0 = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-SPCC_M.2_PCIe_SSD_509D074B162300138574";
    content = {
      type = "gpt";
      partitions = {
        boot = {
          size = "1M";
          type = "EF02";
          priority = 100;
        };
        esp = {
          name = "ESP";
          size = "512M";
          type = "EF00";
          priority = 1000;
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        rootfs = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/nix";
            mountOptions = [ "noatime" ];
          };
        };
      };
    };
  };
  
  # NAS :: disk 1
  disko.devices.disk.nas1 = {
    type = "disk";
    device = "${nas1}";
    content = {
      type = "gpt";
      partitions = {
        media1 = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/mnt/disk1";
            mountOptions = [ "defaults" "noatime" "nodiratime" "user_xattr" ];
            extraArgs = [ "-L" "disk1" ];
          };
        };
      };
    };
  };
  # NAS :: disk 2
  disko.devices.disk.nas2 = {
    type = "disk";
    device = "${nas2}";
    content = {
      type = "gpt";
      partitions = {
        media1 = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/mnt/disk2";
            mountOptions = [ "defaults" "noatime" "nodiratime" "user_xattr" ];
            extraArgs = [ "-L" "disk2" ];
          };
        };
      };
    };
  };
  # NAS :: disk 3
  disko.devices.disk.nas3 = {
    type = "disk";
    device = "${nas3}";
    content = {
      type = "gpt";
      partitions = {
        media1 = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/mnt/disk3";
            mountOptions = [ "defaults" "noatime" "nodiratime" "user_xattr" ];
            extraArgs = [ "-L" "disk3" ];
          };
        };
      };
    };
  };
  
  # DISK :: nflix
  disko.devices.disk.media = {
    type = "disk";
    device = "${nflix}";
    content = {
      type = "gpt";
      partitions = {
        media1 = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/mnt/nflix";
            mountOptions = [ "defaults" "noatime" "nodiratime" "user_xattr" ];
            extraArgs = [ "-L" "nflix" ];
          };
        };
      };
    };
  };
  
  # CEPH :: disk 1
  disko.devices.disk.ceph1 = {
    type = "disk";
    device = "${ceph1}";
    content = {
      type = "gpt";
      partitions.empty.size = "100%";
    };
  };
  # CEPH :: disk 2
  disko.devices.disk.ceph2 = {
    type = "disk";
    device = "${ceph2}";
    content = {
      type = "gpt";
      partitions.empty.size = "100%";
    };
  };
  # CEPH :: disk 3
  disko.devices.disk.ceph3 = {
    type = "disk";
    device = "${ceph3}";
    content = {
      type = "gpt";
      partitions.empty.size = "100%";
    };
  };
  # CEPH :: disk 4
  disko.devices.disk.ceph4 = {
    type = "disk";
    device = "${ceph4}";
    content = {
      type = "gpt";
      partitions.empty.size = "100%";
    };
  };
}
