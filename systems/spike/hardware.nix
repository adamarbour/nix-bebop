{ pkgs, ... }:
{
  # Baseline hardware. Will override profile defaults.
  sys.hw = {
    cpu = "amd";
    gpu = "amd";
    trackpoint.enable = true;
    i2c.enable = true;
    fprint.enable = true;
    yubikey.enable = true;
  };
  # Additional tweaks specific for this system...
  hardware.trackpoint.device = "TPPS/2 Elan TrackPoint";
  networking.networkmanager.wifi.powersave = false;
  networking.wireless.iwd.settings.Settings.PowerSave = false;
  
  systemd.services.ath11k_hibernate = {
    description = "load/unload ath11k to prevent hibernation issues";
    before = [
      "hibernate.target"
      "suspend-then-hibernate.target"
      "hybrid-sleep.target"
    ];
    unitConfig.StopWhenUnneeded = true;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "-${pkgs.kmod}/bin/modprobe -a -r ath11k_pci ath11k";
      ExecStop = "-${pkgs.kmod}/bin/modprobe -a ath11k_pci ath11k";
    };
    wantedBy = [
      "hibernate.target"
      "suspend-then-hibernate.target"
      "hybrid-sleep.target"
    ];
  };
  
  systemd.tmpfiles.rules = [ 
    "w /sys/power/image_size - - - - 0"
    "w /sys/devices/platform/smapi/BAT0/start_charge_thresh - - - - 40"
    "w /sys/devices/platform/smapi/BAT0/stop_charge_thresh - - - - 80"
  ];
}
