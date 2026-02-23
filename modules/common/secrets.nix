{ lib, config, _class, ... }:
let
  inherit (lib) mkEnableOption;
in {
  options.sys.secrets = {
    enable = mkEnableOption "enable sops-nix secrets...";
  };
  
  config = {

  };
}
