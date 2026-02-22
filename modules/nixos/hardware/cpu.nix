{ lib, config ... }:
let
  inherit (lib) types mkOption mkMerge mkIf;
  c = config.sys.hw;
in {
  options.sys.hw.cpu = mkOption {
    type = types.nullOr (types.enum [ "intel" "amd" ]);
    default = null;
    description = ''
      manufacturer of the system cpu
    '';
  };
  
  config = mkMerge [
    (mkIf (c.cpu == "intel") {
      hardware.cpu.intel.updateMicrocode = true;
      boot.kernelModules = [ "kvm-intel" ];
    })
    (mkIf (c.cpu == "amd") {
      hardware.cpu.amd.updateMicrocode = true;
      boot.kernelModules = [ "kvm-amd" "amd-pstate" ];
    })
  ];
}
