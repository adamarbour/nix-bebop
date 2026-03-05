{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.hm.programs.pay-respects;
  zsh = config.programs.zsh;
in {
  options.hm.programs = {
    pay-respects.enable = mkEnableOption "enable pay-respects";
  };
  
  config = mkIf (c.enable) {
    programs.pay-respects = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = zsh.enable; 
    };
  };
}
