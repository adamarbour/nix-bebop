{ lib, pkgs, config, ...}:
let
  inherit (lib) mkIf;
  inherit (config.sys) isGraphical;
in {
  security = {
    polkit.enable = true;
  };
  environment.systemPackages = with pkgs; mkIf (isGraphical) [
    cmd-polkit
    soteria
  ];
}
