{ lib, pkgs, config, ...}:
let
  inherit (lib) genAttrs mkEnableOption mkIf;
  c = config.sys.hw.fprint;
  
  pamServices = [
    "login"
    "sudo"
    "greetd"
    "sddm"
    "polkit-1"
    "swaylock"
    "hyprlock"
  ];
in {
  options.sys.hw.fprint = {
    enable = mkEnableOption "enable fprint support";
  };
  
  config = mkIf (c.enable) {
    services.fprintd.enable = true;
    # Toggle fingerprint auth per selected PAM service
    security.pam.services = genAttrs pamServices (_: { fprintAuth = true; });
  };
}
