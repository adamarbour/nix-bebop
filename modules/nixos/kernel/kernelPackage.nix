{ lib, pkgs, config, ... }:
let
  inherit (lib) types mkOption mkOverride;
  sys = config.sys;
  c = config.sys.boot;

  defaultKernel = if (sys.isGraphical) then pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto
    else if (sys.isServer) then pkgs.cachyosKernels.linuxPackages-cachyos-server-lto
    else pkgs.cachyosKernels.linuxPackages-cachyos-lts-lto;
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
