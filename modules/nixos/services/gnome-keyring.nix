{ lib, pkgs, config, ... }:
let
  inherit (lib) mkEnableOption mkIf mkForce;
  c = config.sys.services.gnome-keyring;
in {
  options.sys.services.gnome-keyring = {
    enable = mkEnableOption "enable gnome-keyring service config";
  };
  
  config = mkIf (c.enable) {
    services.gnome.gnome-keyring.enable = true;
    # Pulled in when gnome-keyring is enabled.
    services.gnome.gcr-ssh-agent.enable = mkForce false;
  };
}
