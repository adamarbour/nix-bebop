{ pkgs, ... }:
{
  sys.packages = {
    inherit (pkgs) dix;
  };
}
