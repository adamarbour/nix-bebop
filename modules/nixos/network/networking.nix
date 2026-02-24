{ lib, config, ... }:
let
  inherit (lib) mkDefault mkForce;
  dnscrypt = config.sys.services.dnscrypt;
in {
  networking = {
    usePredictableInterfaceNames = mkDefault true;
    hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);
    
    # dns
    nameservers =
      if (dnscrypt.enable) then
        [
          "127.0.0.1"
          "::1"
        ]
      else
        [
          "9.9.9.9#dns.quad9.net"
          "2620:fe::fe#dns.quad9.net"
          "1.1.1.1#cloudflare-dns.com"
          "2606:4700:4700::1111#cloudflare-dns.com"
        ];
    
    # Prevent unwanted updates...
    useDHCP = mkForce false;
    dhcpcd.enable = mkForce false;
    dhcpcd.extraConfig = ''
      nohook resolv.conf
    '';

    enableIPv6 = true;
  };
}
