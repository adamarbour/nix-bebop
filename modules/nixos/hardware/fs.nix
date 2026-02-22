{ lib, config, ... }:
let
  inherit (lib) mkMerge mkIf;
  hasBtrfs = (lib.filterAttrs (_: v: v.fsType == "btrfs") config.fileSystems) != { };
in {
  config = mkMerge [
    {
      services.fstrim = {
        enable = true;
        interval = "weekly";
      };
    }
    (mkIf hsBtrfs {
      services.btrfs.autoScrub = {
        enable = true;
        interval = "weekly";
      };
    })
  ];
}
