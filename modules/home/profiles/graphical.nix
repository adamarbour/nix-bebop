{ lib, config, ... }:
let
  inherit (lib) mkIf mkDefault;
  c = config.sys;
in {
  config = mkIf (c.isGraphical) {
    # sane services
    hm.services = {
      # keep-sorted start
      udiskie.enable = mkDefault true;
      kdeconnect.enable = mkDefault true;
      # keep-sorted end
    };
    
    # sane programs
    hm.programs = {
      # keep-sorted start
      nix-index.enable = mkDefault true;
      pay-respects.enable = mkDefault true;
      tealdeer.enable = mkDefault true;
      direnv.enable = mkDefault true;
      carapace.enable = mkDefault true;
      starship.enable = mkDefault true;
      # keep-sorted end
    };
  };
}
