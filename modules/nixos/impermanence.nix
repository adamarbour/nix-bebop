{ lib, config, ... }:
let
  inherit (lib) types mapAttrs' nameValuePair mkOption mkEnableOption mkIf;
  c = config.sys.impermanence;
  persist = config.sys.persist;
  scratch = config.sys.scratch;
  
  # Handle user persistence
  persistUsers = mapAttrs' ( u: uCfg:
    nameValuePair u { inherit (uCfg) directories files; }
  ) persist.users;
  scratchUsers = mapAttrs' ( u: uCfg:
    nameValuePair u { inherit (uCfg) directories files; }
  ) scratch.users;
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
      default = "/scratch";
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
    users = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          directories = mkOption {
            type = types.listOf types.str;
            default = [];
            description = "per-user directories (relative to $HOME) to persist";
          };
          files = mkOption {
            type = types.listOf types.str;
            default = [];
            description = "per-user files (relative to $HOME) to persist";
          };
        };
      });
      default = {};
      description = ''
        per-user persist entries (relative to $HOME)
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
    users = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          directories = mkOption {
            type = types.listOf types.str;
            default = [];
            description = "per-user directories (relative to $HOME) to persist";
          };
          files = mkOption {
            type = types.listOf types.str;
            default = [];
            description = "per-user files (relative to $HOME) to persist";
          };
        };
      });
      default = {};
      description = ''
        per-user persist entries (relative to $HOME)
      '';
    };
  };
  
  config = mkIf (c.enable) {
    fileSystems = {
      "${c.persistRoot}".neededForBoot = true;
      "${c.scratchRoot}".neededForBoot = true;
    };
  
    programs.fuse.userAllowOther = true;
    systemd.tmpfiles.rules = [
      "d ${c.persistRoot} 0755 root root -"
      "d ${c.scratchRoot} 0755 root root -"
      "d ${c.persistRoot}/home 0755 root users -"
      "d ${c.scratchRoot}/home 0755 root users -"
    ];
    
    environment.persistence."${c.persistRoot}" = {
      hideMounts = true;
      inherit (persist) directories;
      inherit (persist) files;
      users = persistUsers;
    };
    
    # Scratch persist is not meant to be backed up but just kept through reboots
    environment.persistence."${c.scratchRoot}" = {
      hideMounts = true;
      inherit (scratch) directories;
      inherit (scratch) files;
      users = scratchUsers;
    };
    
    # Default scratch directories to add ...
    sys.scratch.directories = [
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/cache/nix"
      "/var/log"
    ];
  };
}
