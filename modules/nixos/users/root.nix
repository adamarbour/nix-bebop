{ lib, pkgs, config, ... }:
let
  inherit (lib) mkIf mkDefault mkMerge;
  primaryUser = config.sys.primaryUser;
  secrets = config.sys.secrets;
in {  
  config = {
    users.users.root = mkMerge [
    		{
    		  shell = pkgs.bashInteractive;
      		  openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHTMrsoakrXlUWq3kDT+bKgPqfMX0FgLxiKsTkaO4WX8"
        ];
    		}
    		(mkIf (secrets.enable) {
    			hashedPasswordFile = config.users.users.${primaryUser}.hashedPasswordFile;
    		})
    		(mkIf (!secrets.enable) {
    			# Initial throwaway password: "nixos"
      		initialHashedPassword = mkDefault "$y$j9T$FbXu9/hYPFtVkAy.3JSCs1$XAgWbQs7MbNHP/jH3LRYoxzcwhpQAjY74U7fv40XO94";
    		})
    ];
  };
}
