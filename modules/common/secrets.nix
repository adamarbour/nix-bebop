{ lib, config, sources, _class, ... }:
let
  inherit (lib) types mkOption mkEnableOption mkIf;
  secretsRepo = sources.secrets;
  c = config.sys.secrets;
  root = if config.sys.persist.enable then config.sys.persist.storage.path else null;
  users = config.sys.users;
  home = if (_class == "darwin") then "/Users" else "/home";
in {
  options.sys.secrets = {
    enable = mkEnableOption "enable sops-nix secrets...";
    defaultSopsFile = mkOption {
      type = types.path;
      default = "${secretsRepo}/secrets/default.yaml";
      readOnly = true;
    };
    hostSopsFile = mkOption {
      type = types.path;
      default = "${secretsRepo}/secrets/systems/${config.networking.hostName}.yaml";
      readOnly = true;
    };
  };
  
  config = mkIf (c.enable) {
    sops = {
      inherit (c) defaultSopsFile;
      
      # Pull the user's ssh key
      secrets = ( lib.foldl' ( acc: name:
	      let
          sopsFile = "${secretsRepo}/secrets/users/${name}.yaml";
        in
          acc // {
            "users/${name}/id_ed25519" = {
              inherit sopsFile;
              key = "ssh/key";
              owner = name;
              group = "users";
              mode = "0600";
              # materialize where the user expects it
              path = "${root}${home}/${name}/.ssh/id_ed25519";
            };
            "users/${name}/id_ed25519.pub" = {
              inherit sopsFile;
              key = "ssh/pub";
              owner = name;
              group = "users";
              mode = "0644";
              path = "${root}${home}/${name}/.ssh/id_ed25519.pub";
            };
          }) { }
        users);
    };
  };
}
