{ lib, config, _class, ... }:
let
  inherit (lib) types optional optionalAttrs genAttrs mergeAttrsList mkOption;
  inherit (lib.bebop) groupExist;
in {
  options.sys = {
    primaryUser = mkOption {
      type = types.enum config.sys.users;
      default = builtins.elemAt config.sys.users 0;
      description = ''
        the primary user of the system.
      '';
    };
    users = mkOption {
      type = types.listOf types.str;
      default = [ "adam" ];
      description = ''
        a list of users you wish to include in the system.
      '';
    };
  };
  
  config = {
    users.users = genAttrs config.sys.users (
      name:
      mergeAttrsList [
        (optionalAttrs (_class == "darwin") {
          home = "/Users/${name}";
        })
        (optionalAttrs (_class == "nixos") {
          createHome = true;
          home = "/home/${name}";
          isNormalUser = true;
          extraGroups = [ "wheel" "nix" ] ++ groupExist config [
            # keep-sorted start
            "network"
            "networkmanager"
            "systemd-journal"
            "audio"
            "pipewire"
            "video"
            "input"
            "plugdev"
            "lp"
            "tss"
            "power"
            "git"
            "libvirtd"
            "kvm"
            "incus"
            "incus-admin"
            "docker"
            "podman"
            "cloudflared"
            # keep-sorted end
          ];
        })
      ]
    );
    
    warnings = optional (config.sys.users == [ ]) ''
      You have not added any users to be supported by your system. You may end up with an unbootable system!

      Consider setting {option}`config.sys.users` in your configuration
    '';
  };
}
