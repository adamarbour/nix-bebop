{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.sys.network.networkd;
in {
  options.sys.network.networkd = {
    enable = mkEnableOption "enable systemd-networkd on the system";
  };
  
  config = mkIf (c.enable) {
    networking.useNetworkd = true;
    systemd.network.enable = true;
  };
}
