{ lib, pkgs, config, ... }:
let
  inherit (lib) mkIf;
  s = config.sys.secrets;
  root = if config.sys.impermanence.enable then
    config.sys.impermanence.persistRoot
    else null;
in {
  config = mkIf (s.enable) {
    environment.systemPackages = with pkgs; [ age sops ssh-to-age ];
    sops = {
      age.sshKeyPaths = [ "${root}/etc/ssh/ssh_host_ed25519_key" ];
      gnupg.sshKeyPaths = [];
    };
  };
}
