{ lib, config, _class, ... }:
let
  inherit (lib) types optional optionalAttrs genAttrs mergeAttrsList mkOption mkIf;
  inherit (lib.bebop) groupExist;
  s = config.sys.secrets;
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
          
          # Set user password if secrets are enabled...
          hashedPasswordFile = mkIf (s.enable) config.sops.secrets."users/${name}/passwd".path;
          
          # Add users ssh key to all hosts users is enabled for.
          openssh.authorizedKeys.keyFiles = mkIf (s.enable) [
            config.sops.secrets."users/${name}/id_ed25519.pub".path
          ];
          
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
