{ lib, ... }:
{
  config = {
    boot.loader.timeout = lib.mkDefault 3;
    boot.loader.grub.configurationLimit = lib.mkDefault 5;
    boot.loader.systemd-boot.configurationLimit = lib.mkDefault 5;
    boot.loader.limine.maxGenerations = lib.mkDefault 5;
  };
}
