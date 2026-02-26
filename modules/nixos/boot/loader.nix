{ lib, config, ... }:
let
  inherit (lib) types mkOption mkEnableOption mkDefault;
  c = config.sys.boot;
in {
  options.sys.boot = {
    efi = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Control wether to use efi support or bios support in bootloader.
        '';
      };
      canTouchVars = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Install can modify EFI boot variables.
        '';
      };
    };
    bios.device = mkOption {
      type = types.str;
      default = "nodev";
      description = ''
        device to install bios version of limine to.
      '';
    };
    secureBoot = {
      enable = mkEnableOption "enable secure boot";
    };
  };
  
  config = {
    boot.loader.efi.canTouchEfiVariables = c.efi.canTouchVars;
    
    boot.loader.limine = {
      enable = true;
      enableEditor = mkDefault false;
      
      # bios
      biosSupport = (!c.efi.enable);
      biosDevice = c.bios.device;
      
      # efi
      efiSupport = c.efi.enable;
      
      # secure
      secureBoot.enable = c.secureBoot.enable;
      panicOnChecksumMismatch = c.secureBoot.enable;
      validateChecksums = c.secureBoot.enable;
    };
    
    assertions = [
      {
        assertion = !(c.secureBoot.enable && !c.efi.enable);
        message = ''
          Secure Boot requires EFI to be enabled.
          Set sys.boot.efi.enable = true when enabling sys.boot.secureBoot.enable.
        '';
      }
    ];
    
    warnings =
      lib.optional c.secureBoot.enable ''
        Secure Boot is enabled.

        Make sure you have enrolled your keys using sbctl
        before rebooting, otherwise the system may fail to boot.

        Example:
          sbctl create-keys
          sbctl enroll-keys
      '';
  };
}
