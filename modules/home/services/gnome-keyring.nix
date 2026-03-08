{ lib, pkgs, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.sys) isGraphical;
  c = config.hm.services.gnome-keyring;
in {
  options.hm.services.gnome-keyring = {
    enable = mkEnableOption "enable gnome keyring service";
  };
  
  config = mkIf (c.enable) {
    home.packages = with pkgs; [ seahorse ];
    services.gnome-keyring.enable = true;
    # make sure we're handled through impermanence
    sys.persist.storage.directories = [ "/.local/share/keyrings" ];
  };
}
