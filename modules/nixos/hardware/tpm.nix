{ lib, pkgs, config, ...}:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.sys.hw.tpm;
in {
  options.sys.hw.tpm = {
    enable = mkEnableOption "enable tpm2 support";
  };
  
  config = mkIf (c.enable) {
    security.tpm2 = {
      enable = true;
      abrmd.enable = false;
      tctiEnvironment.enable = true;
      pkcs11.enable = true;
    };
    boot.initrd.kernelModules = [ "tpm" ];
  };
}
