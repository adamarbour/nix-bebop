{ lib, sources, config, ... }:
{
  imports = [
    (sources.sops-nix + "/modules/home-manager/sops.nix") # sops-nix
    (sources.quadlet + "/home-manager-module.nix") # quadlet-nix
  ];
}
