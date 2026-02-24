{ lib, config, ... }:
let
  inherit (lib) types mkOption mkEnableOption;
in {
  options.sys.impermanence = {
    enable = mkEnableOption "enable impermanence on the system";
    persistRoot = mkOption {
      type = types.path;
      default = "/persist";
      description = ''
        base directory used by impermanence that is included in backups and snapshots.
      '';
    };
    scratchRoot = mkOption {
      type = types.path;
      default = "/persist";
      description = ''
        base directory used to keep files through reboots (not backed up).
      '';
    };
  };
  
  options.sys.persist = {
    directories = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        additional paths (absolute) to persist in `persist` root.
      '';
    };
    files = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        additional files (absolute) to persist in `persist` root.
      '';
    };
  };
  options.sys.scratch = {
    directories = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        additional paths (absolute) to persist in `scratch` root.
      '';
    };
    files = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        additional files (absolute) to persist in `scratch` root.
      '';
    };
  };
}
