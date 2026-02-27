{ lib, ... }:
let
  inherit (builtins) filter map toString;
  inherit (lib) filesystem strings;
in {
  imports = filter (strings.hasSuffix ".nix") (
    map toString (filter (p: p != ./default.nix) (filesystem.listFilesRecursive ./.))
  );
}
