{ config, ... }:
{
  config = {
    programs.command-not-found.enable = false;
    programs.nix-index = {
      enable = true;
      enableZshIntegration = config.programs.zsh.enable;
      enableFishIntegration = config.programs.fish.enable;
      enableBashIntegration = true;
    };
  };
}
