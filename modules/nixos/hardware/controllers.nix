{ lib, pkgs, config, ...}:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.sys.hw.controllers;
in {
  options.sys.hw.controllers = {
    enable = mkEnableOption "enable controller support";
  };
  
  config = mkIf (c.enable) {
    hardware = {
      uinput.enable = true;
      steam-hardware.enable = true;
      xpadneo.enable = true;
    };
    services.udev.packages = with pkgs; [
      steam-devices-udev-rules
      game-devices-udev-rules
    ];
  };
}
