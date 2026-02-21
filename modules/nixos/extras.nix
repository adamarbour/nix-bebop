{ lib, sources, config, enableHM ? true, ... }:
{
  imports = [
    (sources.disko + "/module.nix") # disko
    (sources.sops-nix + "/modules/sops") # sops-nix
    (sources.impermanence + "/nixos.nix") # impermanence
  ] ++ lib.optionals (enableHM) [
    (sources.home-manager + "/nixos")
  ];
}
