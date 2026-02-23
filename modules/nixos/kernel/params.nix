{ lib, config, ... }:
let
  inherit (lib) types mkOption;
   c = config.sys.boot;
in {
  options.sys.boot = {
    kernelParams = mkOption {
      type = types.listOf types.str;
      default = [];
    };
  };
  
  config = {
    boot.kernelParams = [
      "nmi_watchdog=0"
      "pti=auto"
      "iommu=pt"
      "noresume"
      # Security
      "oops=panic"
      "randomize_kstack_offset=on"
      "page_alloc.shuffle=1"
      "mitigations=auto,nosmt"
      "slab_nomerge"
      "init_on_alloc=1"
      "init_on_free=1"
    ] ++ c.kernelParams;
  };
}
