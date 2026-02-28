{
  sources ? import ./lon.nix,
  pkgs ? import sources.nixpkgs {},
}:
pkgs.mkShellNoCC {
  NIX_CONFIG = "extra-experimental-features = nix-command flakes";
  NIXPKGS_ALLOW_UNFREE = "1";
  NIX_PATH = "nixpkgs=${pkgs.path}";
  
  packages = with pkgs; [
    # keep-sorted start
    lon
    colmena
    git
    dix
    disko
    cachix
    nixos-anywhere
    age
    sops
    ssh-to-age
    wireguard-tools
    # keep-sorted end
  ];
}
