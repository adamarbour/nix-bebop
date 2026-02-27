{
  device ? throw "missing primary disk for disko",
  ... 
}:
{
  disko.devices.nodev."/" = {
    fsType = "tmpfs";
    mountOptions = [ "defaults" "size=512M" "mode=755" ];
  };
  
  disko.devices.disk.disk0 = {
    type = "disk";
    inherit device;
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
            type = "luks";
            name = "enc";
            settings = {
              allowDiscards = true;
              bypassWorkqueues = true;
            };
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
  };
}
