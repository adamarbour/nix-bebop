{
  imports = [
    # keep-sorted start
    ./networking.nix
    ./networkd.nix
    ./dnscrypt.nix
    ./resolvconf.nix
    ./wireless.nix
    ./networkManager.nix
    ./timezoned.nix
    ./ntp.nix
    ./systemd.nix
    ./tailscale.nix
    ./firewall.nix
    ./fail2ban.nix
    ./optimizeTcp.nix
    ./openssh.nix
    # keep-sorted end
  ];
}
