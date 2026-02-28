{
  # set the build dir to /var/tmp to avoid issues on tmpfs
  nix.settings.build-dir = "/var/lib/nix-build";
  sys.persist.scratch.directories = [ "/var/lib/nix-build" ];
}
