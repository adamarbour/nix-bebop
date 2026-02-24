{ lib, pkgs, ... }:
let
  inherit (lib) mkDefault;
in {
  console = {
    enable = mkDefault true;
    earlySetup = true;
    keyMap = "us";
    font = "${pkgs.terminus_font}/share/consolefonts/ter-d20n.psf.gz";
  };
}
