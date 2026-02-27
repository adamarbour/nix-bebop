{ lib, pkgs, config, ...}:
let
  inherit (lib) elem mkIf mkMerge mkDefault;
  u = config.sys.users;
  secrets = config.sys.secrets;
in {
  config = mkIf (elem "adam" u) {
    users.users.adam = mkMerge [
      {
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGDmKBN5jUyczgWuYmTdtcrtYY+us0nW2kEqHz7nhF0P"
        ];
      }
      (mkIf (!secrets.enable) {
    			# Initial throwaway password: "nixos"
      		initialHashedPassword = mkDefault "$y$j9T$FbXu9/hYPFtVkAy.3JSCs1$XAgWbQs7MbNHP/jH3LRYoxzcwhpQAjY74U7fv40XO94";
    		})
    ];
  };
}
