{ sources ? import ./lon.nix }:
let
  root = import ./default.nix { inherit sources; };
  inherit (root) pkgs lib;
in {
  meta = {
    name = "nix-bebop";
    description = "easy come. easy go.";
    nixpkgs = pkgs;
    specialArgs = { inherit sources lib; };
  };
  defaults = { lib, name, ... }:
  {
    imports = [
      ( { ... }: { _module.args.lib = lib; } ) # myLib
      ./modules/nixos.nix
      ./systems/${name}/configuration.nix
      ./homes
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
  
  # spike :: Lenovo z13 gen1 : Ryzen 7 6860Z / 32GB / 1TB / Radeon 690m
  spike = {
    config = {
      sys.profile = "laptop";
      time.timeZone = "America/Chicago";
      deployment = {
        allowLocalDeployment = true;
      };
      nixpkgs.hostPlatform = "x86_64-linux";
    };
  };
  
  # hammerhead :: racknerd : 1vCPU / 2 GB / 40 GB
  hammerhead = {
    config = {
      sys.profile = "server";
      deployment = {
        tags = [ "infra" ];
        allowLocalDeployment = false;
        targetHost = "172.245.210.47";
        targetUser = "colmena";
      };
      nixpkgs.hostPlatform = "x86_64-linux";
    };
  };
}
