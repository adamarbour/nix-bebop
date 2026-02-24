{
  imports = [
    # keep-sorted start
    ./environment.nix
    ./login-defs.nix
    ./systemd.nix
    ./sudo.nix
    ./polkit.nix
    ./auditd.nix
    # keep-sorted end
  ];
}
