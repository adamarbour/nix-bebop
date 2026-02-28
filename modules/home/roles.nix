 { lib, osConfig, ... }:
 let
  inherit (lib) types mkOption;
 in {
  options.sys.roles = mkOption {
    type = types.listOf types.str;
    default = osConfig.sys.roles;
    readOnly = true;
  };
}
