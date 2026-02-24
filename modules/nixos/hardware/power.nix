{ lib, pkgs, config, ...}:
let
  inherit (lib) mkEnableOption mkIf mkForce;
  c = config.sys.hw.power-management;
in {
  options.sys.hw.power-management = {
    enable = mkEnableOption "enable power-management support";
  };
  
  config = mkIf (c.enable) {
    boot.kernelModules = [ "acpi_call" ];
    boot.extraModulePackages = with config.boot.kernelPackages; [
      acpi_call
      cpupower
    ];
    boot.kernel.sysctl = {
      	"vm.dirty_writeback_centisecs" = 6000;
      	"vm.laptop_mode" = 5;
    };
    
    # POWER-PROFILES (preferred)
    services.power-profiles-daemon.enable = mkForce true;
    
    # POWER MANAGEMENT
    powerManagement = {
      enable = true;
      cpuFreqGovernor = "powersave";
      powertop.enable = true;
    };
    
    # ACPID
    services.acpid.enable = true;
    # THERMALD (conditional on cpu type)
    services.thermald.enable = config.sys.hw.cpu == "intel";
    
    # UPOWER
    services.upower = {
      enable = true;
      percentageLow = 15;
      percentageCritical = 5;
      percentageAction = 3;
      criticalPowerAction = "PowerOff";
    };
    
    # DISABLE
    services.tlp.enable = mkForce false;
    services.auto-cpufreq.enable = mkForce false;
    services.tuned.enable = mkForce false;
    
    environment.systemPackages = [
      pkgs.acpi
      pkgs.powertop
    ];
    
    systemd.tmpfiles.rules = [
      "f /sys/class/rtc/rtc0/wakealarm 0664 root root -"
    ];
  };
}
