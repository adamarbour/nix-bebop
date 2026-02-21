{ lib, config, ... }:
let
  inherit (lib) types mkMerge mkOption mkIf;
in {
  options.sys.packages = mkOption {
    type = types.attrsOf types.package;
    default = {};
    description = ''
      A set of packages to install.
    '';
  };
  
   config = mkMerge [
    (mkIf (config.sys.class == "nixos" || config.sys.class == "darwin") {
      environment.systemPackages = builtins.attrValues config.sys.packages;
    })

#    (mkIf (config.sys.class == "home") {
#      home.packages = builtins.attrValues config.sys.packages;
#    })
  ];
}
