{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.hm.programs.carapace;
  zsh = config.programs.zsh;
in {
  options.hm.programs = {
    carapace.enable = mkEnableOption "enable multi-shell completion" // { default = true; };
  };
  
  config = mkIf (c.enable) {
    programs.carapace = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = zsh.enable; 
    };
  };
}
