{ lib, pkgs, config, ...}:
let
  inherit (lib) elem mkIf;
  u = config.sys.users;
in {
  config = mkIf (elem "adam" u) {
    users.users.adam = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGDmKBN5jUyczgWuYmTdtcrtYY+us0nW2kEqHz7nhF0P"
      ];
    };
  };
}
