{ lib, config, sources, ... }:
let
  inherit (lib) mkDefault;
in {
  nix = {
    channel.enable = false;
    registry.nixpkgs.to = {
      type = "path";
      path = sources.nixpkgs;
    };
    nixPath = ["nixpkgs=flake:nixpkgs"];

    optimise = {
      automatic = mkDefault (!config.boot.isContainer);
      dates = [ "04:00" ];
    };
    
    gc = {
      automatic = true;
      dates = "Mon *-*-* 03:00";
      options = "--delete-older-than 5d";
    };
  };
}
