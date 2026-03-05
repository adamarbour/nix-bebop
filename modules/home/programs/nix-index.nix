{ lib, pkgs, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.hm.programs.nix-index;
  zsh = config.programs.zsh;
in {
  options.hm.programs = {
    nix-index.enable = mkEnableOption "enable nix-index";
  };
  
  config = mkIf (c.enable) {  
    programs.nix-index = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = zsh.enable; 
    };
    
    home.packages = with pkgs; [ manix ];
  };
}
