{ lib, pkgs, config, ... }:
let
  inherit (lib) mkIf;
  inherit (config.sys) isGraphical;
in
{
  config = mkIf (isGraphical) {
    sys.persist = {
      storage.directories = [
        "${config.xdg.configHome}"
        "${config.xdg.userDirs.documents}"
        "${config.xdg.userDirs.download}"
        "${config.xdg.userDirs.desktop}"
        "${config.xdg.userDirs.videos}"
        "${config.xdg.userDirs.music}"
        "${config.xdg.userDirs.pictures}"
        "${config.home.homeDirectory}/Projects"
      ];
      scratch.directories = [
        "${config.xdg.cacheHome}"
        "${config.xdg.dataHome}"
        "${config.xdg.stateHome}"
        "${config.xdg.userDirs.publicShare}"
        "${config.xdg.userDirs.templates}"
      ];
    };
    
    xdg = {
      enable = true;
      cacheHome = "${config.home.homeDirectory}/.cache";
      configHome = "${config.home.homeDirectory}/.config";
      dataHome = "${config.home.homeDirectory}/.local/share";
      stateHome = "${config.home.homeDirectory}/.local/state";
      
      userDirs = {
        enable = true;
        createDirectories = true;
        
        documents = "${config.home.homeDirectory}/Documents";
        download = "${config.home.homeDirectory}/Downloads";
        desktop = "${config.home.homeDirectory}/Desktop";
        videos = "${config.home.homeDirectory}/Media/Videos";
        music = "${config.home.homeDirectory}/Media/Music";
        pictures = "${config.home.homeDirectory}/Media/Pictures";
        publicShare = "${config.home.homeDirectory}/public/share";
        templates = "${config.home.homeDirectory}/public/templates";
        
        extraConfig = {
          XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Media/screenshots";
          XDG_DEV_DIR = "${config.home.homeDirectory}/Projects";
        };
      };
    };
    
    home.packages = with pkgs; [
      xdg-utils
      xdg-terminal-exec-mkhl
    ];
  };
}
