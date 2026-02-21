 { lib, config, ... }:
 let
  inherit (lib) types mkOption;
  p = config.sys.profile or null;
  profileList = [ "desktop" "laptop" "server" "virtual" ];
 in {
  options.sys = {
    profile = mkOption {
      type = types.enum profileList;
      description = ''
        Defines `sane defaults` for the type of system.
      '';
    };
    isDesktop = mkOption {
      type = types.bool;
      default = p == "desktop";
      readOnly = true;
    };
    isLaptop = mkOption {
      type = types.bool;
      default = p == "laptop";
      readOnly = true;
    };
    isServer = mkOption {
      type = types.bool;
      default = p == "server";
      readOnly = true;
    };
    isGraphical = mkOption {
      type = types.bool;
      default = (p == "desktop" || p == "laptop");
      readOnly = true;
    };
    isContainer = mkOption {
      type = types.bool;
      default = (config.boot.isContainer);
      readOnly = true;
    };
    isVM = mkOption {
      type = types.bool;
      default = p == "virtual";
      readOnly = true;
    };
  };
}
