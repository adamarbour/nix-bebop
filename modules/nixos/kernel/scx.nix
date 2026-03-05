{ lib, config, ... }:
let
  inherit (lib) mkDefault;
  inherit (config.sys) isGraphical;
in {
  config = {
    services.scx = {
      enable = isGraphical;
      package = pkgs.scx.rustscheds;
      scheduler = mkDefault "scx_bpfland"; 
    };
  };
}
