{ lib, config, _class, ... }:
let
  inherit (lib) types mkOption;
  platform = config.nixpkgs.hostPlatform;
in {
  options.sys = {
    class = mkOption {
      type = types.nullOr types.str;
      default = _class;
      internal = true;
    };
    isLinux = mkOption {
      type = types.bool;
      default = platform.isLinux;
      internal = true;
    };
    isDarwin = mkOption {
      type = types.bool;
      default = platform.isDarwin;
      internal = true;
    };
    isX86 = mkOption {
      type = types.bool;
      default = platform.isx86_64;
      internal = true;
    };
    isArm = mkOption {
      type = types.bool;
      default = platform.isAarch64;
      internal = true;
    };
  };
}
