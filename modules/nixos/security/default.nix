{
  imports = [
    # keep-sorted start
    ./environment.nix
    ./login-defs.nix
    ./systemd.nix
    ./sudo.nix
    ./polkit.nix
    ./auditd.nix
    ./colmena.nix
    ./adam.nix
    # keep-sorted end
  ];
}
