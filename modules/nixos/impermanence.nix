{ lib, config, ... }:
let
  inherit (builtins) attrNames baseNameOf mapAttrs;
  inherit (lib) genAttrs mkAfter mkOption mkMerge types unique mkIf;
  c = config.sys.persist;
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
    fileSystems."${c.path}".neededForBoot = true;
    
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
      # TODO: Handle users from sys.users;
    };
    
    # persist with snapshots
    environment.persistence."${c.storage.path}" = {
      inherit (c) enable;
      hideMounts = true;
      directories = unique ([
          "/var/lib/nixos"
        ] ++ c.storage.directories);
      files = unique ([] ++ c.storage.files);
      # TODO: Handle users from sys.users;
    };
    
  };
}
