{
  imports = [
    # keep-sorted start
    ./boot
    ./nix
    ./profiles
    ./hardware
    ./kernel
    ./users
    ./network
    ./security
    ./environment
    ./services
    ./extras.nix
    ./impermanence.nix
    ./secrets.nix
    ./displayManager.nix
    # keep-sorted end
  ];
}
