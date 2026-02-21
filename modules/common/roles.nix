 { lib, config, ... }:
 let
  inherit (lib) types mkOption;
 in {
  options.sys.roles = mkOption {
    type = types.listOf types.str;
    default = [];
    apply = lib.unique;
  };
}
