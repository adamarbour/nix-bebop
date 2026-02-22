{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.sys.boot.silentBoot;
in {
  options.sys.boot.silentBoot = {
    enable = mkEnableOption "enable silent boot";
  };
  
  config = mkIf (c.enable) {
    boot.kernelParams = [
      "quiet"
      "loglevel=3"
      "udev.log_level=3"
      "rd.udev.log_level=3"
      "systemd.show_status=auto"
      "rd.systemd.show_status=auto"
      "vt.global_cursor_default=0"
    ];
  };
}
