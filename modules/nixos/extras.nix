{ lib, sources, config, ... }:
{
  imports = [
    (sources.disko + "/module.nix") # disko
    (sources.sops-nix + "/modules/sops") # sops-nix
    (sources.impermanence + "/nixos.nix") # impermanence
    (sources.quadlet + "/nixos-module.nix") # quadlet-nix
    (sources.home-manager + "/nixos") # home-manager
    (sources.nix-topology + "/nixos/module.nix") # nix-topology
  ];
}
