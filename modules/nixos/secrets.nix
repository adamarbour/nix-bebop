{ lib, pkgs, config, ... }:
let
  inherit (lib) mkIf;
  s = config.sys.secrets;
  root = if config.sys.persist.enable then config.sys.persist.storage.path else null;
  users = config.sys.users;
in {
  config = mkIf (s.enable) {
    environment.systemPackages = with pkgs; [ age sops ssh-to-age ];
    sops = {
      age.sshKeyPaths = [ "${root}/etc/ssh/ssh_host_ed25519_key" ];
      gnupg.sshKeyPaths = [];
      
      
    };
  };
}
