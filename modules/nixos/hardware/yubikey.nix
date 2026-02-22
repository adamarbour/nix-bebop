{ lib, pkgs, config, ...}:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.sys.hw.yubikey;
in {
  options.sys.hw.yubikey = {
    enable = mkEnableOption "enable yubikey support";
  };
  
  config = mkIf (c.enable) {
    hardware.gpgSmartcards.enable = true;
    
    services.pcscd.enable = true;
    services.udev.packages = [ pkgs.yubikey-personalization ];
    
    sys.packages  = {
      inherit (pkgs) yubikey-manager;
    };
  };
}
