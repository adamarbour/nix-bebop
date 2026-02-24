{ lib, config, sources, _class, ... }:
let
  inherit (lib) types mkOption mkEnableOption mkIf;
  secretsRepo = sources.secrets;
  c = config.sys.secrets;
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
    };
  };
}
