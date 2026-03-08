{ lib, pkgs, config, sources, ... }:
let
  inherit (lib) types mkIf mkOption mkEnableOption mkMerge mkDefault mkForce;
  lanzaboote = import sources.lanzaboote { inherit pkgs; };
  c = config.sys.boot;
in {
  imports = [ lanzaboote.nixosModules.lanzaboote ];
  
  options.sys.boot = {
    loader = mkOption {
      type = types.enum [
        "none"
        "grub"
        "systemd"
        "lanzaboote"
      ];
      default = "systemd";
      description = "The bootloader that should be used for the device.";
    };
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
  };
  
  config = mkMerge [
    {
      boot.loader.efi.canTouchEfiVariables = c.efi.canTouchVars;
      environment.systemPackages = with pkgs; [ sbctl ];
      sys.persist.storage.directories = [ "/var/lib/sbctl" ];
    }
    
    # none
    (mkIf (c.loader == "none") {
      boot.loader = {
        grub.enable = mkForce false;
        systemd-boot.enable = mkForce false;
      };
    })
    
    # grub for bios
    (mkIf (c.loader == "grub") {
      boot.loader.grub = {
        enable = true;
        inherit (c.bios) device;
        useOSProber = mkDefault false;
        efiSupport = c.efi.enable;
        theme = null;
        backgroundColor = null;
        splashImage = null;
      };
    })
    
    # systemd for efi
    (mkIf (c.loader == "systemd") {
      boot.loader.systemd-boot = {
        enable = true;
        consoleMode = mkDefault "max";
        editor = false;
      };
    })
    
    # lanzaboote for secureboot
    (mkIf (c.loader == "lanzaboote") {
      boot.loader.grub.enable = mkForce false;
      boot.loader.systemd-boot.enable = mkForce false;
      boot.lanzaboote = {
        enable = true;
        autoGenerateKeys.enable = true;
        autoEnrollKeys.enable = true;
        pkiBundle = "/var/lib/sbctl";
      };
    })
  ];
}
