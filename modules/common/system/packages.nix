{ lib, config, ... }:
let
  inherit (lib) types mergeAttrsList optionalAttrs mkOption;
  inherit (config) sys;
in {
  options.sys.packages = mkOption {
    type = types.attrsOf types.package;
    default = {};
    description = ''
      A set of packages to install.
    '';
  };
  
  config = mergeAttrsList [
    (optionalAttrs (sys.class == "nixos" || sys.class == "darwin") {
      environment.systemPackages = builtins.attrValues config.sys.packages;
    })
    (optionalAttrs (sys.class == "home") {
      home.packages = builtins.attrValues config.sys.packages;
    })
  ];
}
