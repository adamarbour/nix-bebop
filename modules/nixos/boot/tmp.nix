{ lib, config, ... }:
let
  inherit (lib) types mkOption mkDefault;
  c = config.sys.boot;
in {
  options.sys.boot.tmpOnTmpfs = mkOption {
    type = types.bool;
    default = true;
    description = ''
      `/tmp` is on tmpfs. False implies its cleaned each boot.
    '';
  };
  
  config = {
    boot.tmp = {
      useTmpfs = c.tmpOnTmpfs;
      tmpfsHugeMemoryPages = mkDefault "within_size";
      cleanOnBoot = (!config.boot.tmp.useTmpfs);
    };
  };
}
