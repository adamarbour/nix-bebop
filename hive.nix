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
      sys.users = [ "adam" ];
      sys.secrets.enable = true;
      time.timeZone = "America/Chicago";
      deployment = {
        allowLocalDeployment = true;
        targetHost = "10.12.34.101";
        targetUser = "adam";
      };
      nixpkgs.hostPlatform = "x86_64-linux";
    };
  };
  
  # hammerhead :: racknerd : 1vCPU / 2 GB / 40 GB
  hammerhead = {
    config = {
      sys.profile = "server";
      sys.users = [ "adam" ];
      sys.secrets.enable = true;
      deployment = {
        tags = [ "infra" ];
        allowLocalDeployment = false;
        targetHost = "10.12.34.56"; # pub: 172.245.210.47
        targetUser = "colmena";
      };
      nixpkgs.hostPlatform = "x86_64-linux";
    };
  };
}
