{ sources ? import ./lon.nix }:
let
  root = import ./default.nix {};
  inherit (root) pkgs lib;
in {
  meta = {
    name = "nix-bebop";
    description = "easy come. easy go.";
    nixpkgs = pkgs;
    specialArgs = { inherit sources lib; enableHM = true; }; # Allow per-host disable of home-manager
  };
  defaults = { lib, name, ... }:
  {
    imports = [
      ( { ... }: { _module.args.lib = lib; } ) # myLib
      ./modules/nixos.nix
      ./systems/${name}/configuration.nix
    ];
    config = {
      networking.hostName = name;
      deployment.allowLocalDeployment = lib.mkDefault false;
      deployment.targetUser = lib.mkDefault null;
    };
  };
  # ██████╗  ███████╗ ██████╗   ██████╗  ██████╗ 
  # ██╔══██╗ ██╔════╝ ██╔══██╗ ██╔═══██╗ ██╔══██╗
  # ██████╔╝ █████╗   ██████╔╝ ██║   ██║ ██████╔╝
  # ██╔══██╗ ██╔══╝   ██╔══██╗ ██║   ██║ ██╔═══╝ 
  # ██████╔╝ ███████╗ ██████╔╝ ╚██████╔╝ ██║     
  # ╚═════╝  ╚══════╝ ╚═════╝   ╚═════╝  ╚═╝ 
  
  # spike : Lenovo z13 gen1 / 32GB / 1TB / Radeon 690m
  spike = {
    config = {
      time.timeZone = "America/Chicago";
      deployment = {
        allowLocalDeployment = true;
      };
      nixpkgs.hostPlatform = "x86_64-linux";
    };
  };
}
