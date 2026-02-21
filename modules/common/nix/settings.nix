{ pkgs, config, ... }:
let
  inherit (config) sys;
  admins = if (sys.class == "darwin") then "@admin" else "@wheel";
in {
  nix.settings = {
    allowed-users = [ admins ];
    trusted-users = [ "root" admins ];
    
    min-free = 5 * 1024 * 1024 * 1024; # 5GB
    max-free = 10 * 1024 * 1024 * 1024; # 10GB

    keep-derivations = true;
    keep-outputs = true;
    keep-going = true;
    
    builders-use-substitutes = true;

    max-jobs = "auto";
    cores = 0;

    http-connections = 50;
    connect-timeout = 2;
    stalled-download-timeout = 10;
    log-lines = 30;
    
    sandbox = pkgs.stdenv.hostPlatform.isLinux;
    
    system-features = [
      "nixos-test"
      "kvm"
      "recursive-nix"
      "big-parallel"
      "uid-range"
    ];

    # we do not want these...
    auto-optimise-store = false;
    fallback = false;

    experimental-features = [
      "nix-command"
      "flakes"
      "auto-allocate-uids"
      "ca-derivations"
      "cgroups"
      "fetch-closure"
    ];
    
    auto-allocate-uids = true;
    use-xdg-base-directories = true;
    use-cgroups = true;
    warn-dirty = false;
  };
}
