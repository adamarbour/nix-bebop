{
  sources ? import ./lon.nix,
  pkgs ? import sources.nixpkgs {},
}:
pkgs.mkShellNoCC {
  NIX_CONFIG = "extra-experimental-features = nix-command flakes";
  NIX_PATH = "nixpkgs=${pkgs.path}";
  
  packages = with pkgs; [
    # keep-sorted start
    lon
    colmena
    git
    dix
    disko
    cachix
    # keep-sorted end
  ];
}
