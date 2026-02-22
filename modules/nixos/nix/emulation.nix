{ lib, pkgs, config, ... }:
let
  inherit (lib) types elemAt splitString flip filter genAttrs pipe mkEnableOption mkOption mkIf;
  getArch = flip pipe [
    (splitString "-")
    (flip elemAt 0)
  ];
  c = config.sys.emulation;
in {
  options.sys.emulation = {
    enable = mkEnableOption "emulation for addition architectures.";
    systems = mkOption {
      type = types.listOf types.str;
      default = filter (system: system != pkgs.stdenv.hostPlatform.system) [
        "x86_64-linux" "aarch64-linux" "i686-linux"
      ];
      description = ''
        systems to enable emulation for
      '';
    };
  };
  
  config = mkIf (c.enable) {
    nix.settings.extra-sandbox-paths = [
      "/run/binfmt"
      (toString pkgs.qemu)
    ];
    
    boot.binfmt = {
      emulatedSystems = c.systems;
      registrations = genAttrs c.systems (system: {
        interpreter = "${pkgs.qemu}/bin/qemu-${getArch system}";
      });
    };
  };
}
