{ lib, config, ... }:
let
  inherit (builtins) attrNames baseNameOf hasAttr mapAttrs;
  inherit (lib) genAttrs mkAfter mkOption mkMerge types unique mkIf;
  c = config.sys.persist;
  users = config.home-manager.users or {};
in {
  options.sys.persist = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        enable persistent storage location
      '';
    };
    path = mkOption {
      type = types.str;
      default = "/nix";
      description = ''
        path to the main persist mount
      '';
    };
    
    # survives reboots and is backed up
    storage = {
      path = mkOption {
        type = types.str;
        default = "${c.path}/persist";
      };
      directories = mkOption {
        type = with types; listOf (either str attrs);
        default = [];
        description = ''
          system directories to persist reboots and snapshot
        '';
        example = [ "/etc/nixos" ];
      };
      files = mkOption {
        type = with types; listOf (either str attrs);
        default = [];
        description = ''
          system files to persist reboots and snapshot
        '';
        example = [ "/etc/machine-id" ];
      };
    };
    
    # survives reboots but is not backed up
    scratch = {
      path = mkOption {
        type = types.str;
        default = "${c.path}/scratch";
      };
      directories = mkOption {
        type = with types; listOf (either str attrs);
        default = [];
        description = ''
          system directories to persist reboots and snapshot
        '';
        example = [ "/etc/nixos" ];
      };
      files = mkOption {
        type = with types; listOf (either str attrs);
        default = [];
        description = ''
          system files to persist reboots and snapshot
        '';
        example = [ "/etc/machine-id" ];
      };
    };
  };
  
  config = mkIf (c.enable) {
    programs.fuse.userAllowOther = true;
    fileSystems = let
     userDirs = type:
        map (x: x.dirPath)
        (builtins.filter (d: builtins.substring 0 1 d.directory != "." && d.home != null)
          config.environment.persistence."${c."${type}".path}".directories);      
    in mkMerge [
      # hint gvfs that these mounts support trash (where applicable)
      (
        genAttrs
          ((userDirs "scratch") ++ (userDirs "storage"))
          (_: {options = ["x-gvfs-trash"];})
      )
      { "${c.path}".neededForBoot = true; }
    ];
    
    # persist without snapshots
    environment.persistence."${c.scratch.path}" = {
      inherit (c) enable;
      hideMounts = true;
      directories = unique ([
          "/var/lib/systemd/coredump"
          "/var/cache/nix"
          "/var/log"
        ] ++ c.scratch.directories);
      files = unique ([] ++ c.scratch.files);
      # Include users directories and files from hm
      users =
        mapAttrs (_: user: {
          directories = unique ([] ++ user.sys.persist.scratch.directories);
          files = unique user.sys.persist.scratch.files;
        })
        users;
    };
    
    # persist with snapshots
    environment.persistence."${c.storage.path}" = {
      inherit (c) enable;
      hideMounts = true;
      directories = unique ([
          "/var/lib/nixos"
        ] ++ c.storage.directories);
      files = unique ([] ++ c.storage.files);
       # Include users directories and files from hm
      users =
        mapAttrs (_: user: {
          directories = unique ([] ++ user.sys.persist.storage.directories);
          files = unique user.sys.persist.storage.files;
        })
        users;
    };
    
  };
}
