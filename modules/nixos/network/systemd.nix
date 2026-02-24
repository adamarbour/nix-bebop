{ lib, ... }:
let
  inherit (lib) mkDefault;
in {
  config = {
    systemd.services.systemd-networkd.stopIfChanged = false;
    systemd.services.systemd-resolved.stopIfChanged = false;
    # Don't wait for online
    systemd.network.wait-online.enable = mkDefault false;
    systemd.services.NetworkManager-wait-online.enable = mkDefault false;
  };
}
