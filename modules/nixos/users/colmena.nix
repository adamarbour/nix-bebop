{ lib, pkgs, config, ...}:
let
  inherit (lib) mkIf mkAfter mkDefault;
  c = config.deployment;
in {
  config = mkIf (!c.allowLocalDeployment) {
    users.users.colmena = {
      hashedPassword = mkDefault "!";
      isNormalUser = true;
      createHome = true;
      home = "/var/lib/colmena";
      description = "Remote Deploy";
      shell = pkgs.bashInteractive;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGDmKBN5jUyczgWuYmTdtcrtYY+us0nW2kEqHz7nhF0P"
      ];
    };
    
    nix.settings = {
      trusted-users = mkAfter [ "colmena" ];
      allowed-users = mkAfter [ "colmena" ];
    };
    services.displayManager.hiddenUsers = [ "colmena"];
    sys.persist.scratch.directories = [ "/var/lib/colmena" ];
  };
}
