{ pkgs, ... }:
{
  config.environment.variables = {
    NIX_PATH = "nixpkgs=${pkgs.path}";
  };
}
