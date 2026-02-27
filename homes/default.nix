{ lib, pkgs, config, sources, ... }:
let
  inherit (lib) genAttrs mkEnableOption mkIf;
  c = config.hm;
in {
  options.hm = {
    enable = mkEnableOption "enable the evaluation and loading of home manager modules"
    // { default = true; };
  };
  
  config = mkIf c.enable {
    environment.systemPackages = with pkgs; [ home-manager ];
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      backupFileExtension = "old";
      
      users = genAttrs config.sys.users (name: {
        imports = [ ./${name} ];
      });
      
      extraSpecialArgs = {
        inherit sources;
        bebop = lib.bebop;
        osConfig = config;
      };
      
      sharedModules = [
        ({ lib, bebop, ...}: { _module.args.lib = lib.extend (final: prev: { bebop = bebop; }); })
        ../modules/hm.nix
      ];
    };
  };
}
