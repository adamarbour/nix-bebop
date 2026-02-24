{ lib, pkgs, config, ...}:
let
  inherit (lib) mkIf genAttrs;
  inherit (config.sys) isGraphical;
in {
  config = mkIf isGraphical {
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
