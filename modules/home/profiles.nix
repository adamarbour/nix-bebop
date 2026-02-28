 { lib, osConfig, ... }:
 let
  inherit (lib) types mkOption;
 in {
  options.sys = {
    profile = mkOption {
      type = types.str;
      description = ''
        Defines `sane defaults` for the type of system.
      '';
      default = osConfig.sys.profile;
      readOnly = true;
    };
    isDesktop = mkOption {
      type = types.bool;
      default = osConfig.sys.isDesktop;
      readOnly = true;
    };
    isLaptop = mkOption {
      type = types.bool;
      default = osConfig.sys.isLaptop;
      readOnly = true;
    };
    isServer = mkOption {
      type = types.bool;
      default = osConfig.sys.isServer;
      readOnly = true;
    };
    isGraphical = mkOption {
      type = types.bool;
      default = osConfig.sys.isGraphical;
      readOnly = true;
    };
    isContainer = mkOption {
      type = types.bool;
      default = osConfig.sys.isContainer;
      readOnly = true;
    };
  };
}
