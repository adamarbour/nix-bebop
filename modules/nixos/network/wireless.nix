{ lib, config, ... }:
let
  inherit (lib) optionals mkOption types;
  c = config.sys.network.wireless;
in {
  options.sys.network.wireless = {
    backend = mkOption {
      type = types.enum [
        "iwd"
        "wpa_supplicant"
        "none"
      ];
      default = "none";
      description = ''
        Backend that will be used for wireless connections using either `networking.wireless`
        or `networking.networkmanager.wifi.backend`
      '';
    };
  };

  config = {
    # enable wireless database, it helps keeping wifi speedy
    hardware.wirelessRegulatoryDatabase = true;
    
    sys.scratch.directories = optionals (c.backend == "iwd") [
      "/var/lib/iwd"
    ]
    ++ optionals (c.backend == "wpa_supplicant") [
      "/var/lib/wpa_supplicant"
    ];
    
    networking.wireless = {
      # WPA_SUPPLICANT
      enable = c.backend == "wpa_supplicant";
      userControlled.enable = true;
      allowAuxiliaryImperativeNetworks = true;

      extraConfig = ''
        update_config=1
      '';

      # IWD
      iwd = {
        enable = c.backend == "iwd";
        settings = {
          Settings.AutoConnect = true;
          General = {
            EnableNetworkConfiguration = true;
            RoamRetryInterval = 15;
          };
          Network = {
            EnableIPv6 = true;
            RoutePriorityOffset = 600;
          };
        };
      };
    };
  };
}
