{ lib, sources, config, ... }:
{
  imports = [
    (sources.direnv-instant + "/home.nix") # direnv-instant
    (sources.sops-nix + "/modules/home-manager/sops.nix") # sops-nix
    (sources.quadlet + "/home-manager-module.nix") # quadlet-nix
  ];
}
