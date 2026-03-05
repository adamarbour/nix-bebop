{
  imports = [
    # keep-sorted start
    ./nix/environment.nix
    ./nix/nix.nix
    ./nix/settings.nix
    ./nix/tools.nix
    ./nix/substituters.nix
    ./system/fonts.nix
    ./system/version.nix
    ./system/packages.nix
    ./system/platform.nix
    ./profiles.nix
    ./users.nix
    ./secrets.nix
    # keep-sorted end
  ];
}
