{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.sys.services.dnscrypt;
in {
  options.sys.services.dnscrypt = {
    enable = mkEnableOption "enable dnscrypt service";
  };
  
  config = mkIf (c.enable) {
    services.dnscrypt-proxy = {
      enable = true;
      settings = {
        listen_addresses = [
          "127.0.0.1:53"
          "[::1]:53"
        ];

        sources.public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          ];
          cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        };

        server_names = [ "nextdns-88bdf4" "nextdns" "nextdns-ipv6" "mullvad-adblock-doh" "quad9-dnscrypt-ipv4-filter-pri" "quad9-dnscrypt-ip6-filter-pri" ];
        static."nextdns-88bdf4".stamp = "sdns://AgEAAAAAAAAAAAAOZG5zLm5leHRkbnMuaW8HLzg4YmRmNA";

        ipv6_servers = true;
        require_dnssec = true;
        require_nolog = true;
        require_nofilter = false;

        cache = true;
        cache_size = 4096;

        timeout = 2500;
      };
    };
  };
}
