{ lib, pkgs, config, ...}:
let
  inherit (lib) mkEnableOption mkIf mkForce;
  c = config.sys.hw.audio;
in {
  options.sys.hw.audio = {
    enable = mkEnableOption "enable audio support";
  };
  
  config = mkIf (c.enable) {
    security.rtkit.enable = mkForce config.services.pipewire.enable;
    services.pulseaudio.enable = !config.services.pipewire.enable;
    services.pipewire.wireplumber.enable = config.services.pipewire.enable;
    environment.systemPackages = with pkgs; [
      alsa-utils
      pwvucontrol
      easyeffects
      wiremix
    ];
    
    # Pipewire
    services.pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    
    systemd.user.services = {
      pipewire.wantedBy = [ "default.target" ];
      pipewire-pulse.wantedBy = [ "default.target" ];
    };
    
    services.udev.extraRules = ''
      KERNEL=="rtc0", GROUP="audio"
      KERNEL=="hpet", GROUP="audio"
    '';
    
    security.pam.loginLimits = [
      {
        domain = "@audio";
        item = "memlock";
        type = "-";
        value = "unlimited";
      }
      {
        domain = "@audio";
        item = "rtprio";
        type = "-";
        value = "99";
      }
      {
        domain = "@audio";
        item = "nofile";
        type = "soft";
        value = "99999";
      }
      {
        domain = "@audio";
        item = "nofile";
        type = "hard";
        value = "524288";
      }
    ];
  };
}
