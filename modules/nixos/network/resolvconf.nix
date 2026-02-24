{ lib, config, ... }:
let
  inherit (lib) mkIf mkForce;
  dnscrypt = config.sys.services.dnscrypt;
in {
  config = {
    # Disable if dnscrypt-proxy is enabled...
    services.resolved = {
      enable = mkForce (!dnscrypt.enable);
      llmnr = "true";
      dnsovertls = "true";
      dnssec = "allow-downgrade";
      domains = [ "~." ];
      fallbackDns = mkForce [  ];
    };
    networking.resolvconf.enable = mkForce false;

    environment.etc."resolv.conf".text = mkIf (dnscrypt.enable) ''
      nameserver 127.0.0.1
      nameserver ::1
      options edns0 trust-ad
    '';
  };
}
