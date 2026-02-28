{ lib, pkgs, config, sources, ... }:
let
  inherit (lib) mkIf;
  secretsRepo = sources.secrets;
  s = config.sys.secrets;
  root = if config.sys.persist.enable then config.sys.persist.storage.path else null;
  users = config.sys.users;
in {
  config = mkIf (s.enable) {
    environment.systemPackages = with pkgs; [ age sops ssh-to-age ];
    sops = {
      age.sshKeyPaths = [ "${root}/etc/ssh/ssh_host_ed25519_key" ];
      gnupg.sshKeyPaths = [];
      
      secrets = ( lib.foldl' ( acc: name:
	      let
          sopsFile = "${secretsRepo}/secrets/users/${name}.yaml";
        in
          acc // {
            "users/${name}/passwd" = {
              inherit sopsFile;
              key = "passwd";
              neededForUsers = true;
            };
          }) { }
        users);
    };
  };
}
