{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.hm.programs.direnv;
  zsh = config.programs.zsh;
in {
  options.hm.programs = {
    direnv.enable = mkEnableOption "enable direnv";
  };
  
  config = mkIf (c.enable) {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
      enableZshIntegration = zsh.enable; 
    };
    
    programs.direnv-instant = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = zsh.enable; 
    };
  };
}
