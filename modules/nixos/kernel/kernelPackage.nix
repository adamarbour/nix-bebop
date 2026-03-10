{ lib, pkgs, config, ... }:
let
  inherit (lib) types mkOption mkOverride;
  sys = config.sys;
  c = config.sys.boot;

  defaultKernel = if (sys.isGraphical) then pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto
    else if (sys.isServer) then pkgs.linuxPackages
    else pkgs.linuxPackages_xanmod_latest;
in {
  options.sys.boot = {
    kernel = mkOption {
      type = types.raw;
      default = defaultKernel;
      defaultText = "${defaultKernel}";
      description = "The kernel to use for the system.";
    };
  };

  config = {
    boot.kernelPackages = mkOverride 500 c.kernel;
  };
}
