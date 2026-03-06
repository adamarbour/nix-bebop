{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.hm.programs.starship;
  zsh = config.programs.zsh;
in {
  options.hm.programs = {
    starship.enable = mkEnableOption "enable starship prompt";
  };
  
  config = mkIf (c.enable) {
    programs.starship = {
      enable = true;
      enableInteractive = true;
      enableBashIntegration = true;
      enableZshIntegration = zsh.enable; 
    };
  };
}
