{
  imports [
    ./disk.nix { device = "/dev/nvme0n1"; }
  ];
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
}
