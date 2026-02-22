{ lib, config ... }:
let
  inherit (lib) types mkOption mkMerge mkIf;
  c = config.sys.hw;
  prime = config.sys.hw.prime;
in {
  options.sys.hw.gpu = mkOption {
    type = types.nullOr (types.enum [ "intel" "amd" "nvidia" ]);
    default = null;
    description = ''
      manufacturer of the system gpu
    '';
  };
  
  config = mkMerge [
    (mkIf (c.cpu == "intel") {
      boot.kernelModules = [ "i915" ];
      boot.kernelParams = [ "i915.fastboot=1" ];
      
      services.xserver.videoDrivers = mkIf (!prime.enable) [ "modesetting" ];
      hardware.graphics = {
        extraPackages = with pkgs; [
          intel-media-driver
          intel-compute-runtime
          vpl-gpu-rt
        ];
        extraPackages32 = with pkgs.pkgsi686Linux; [
          intel-media-driver
        ];
      };
      environment.systemPackages = with pkgs; [
        nvtopPackages.intel
      ];
    })
    (mkIf (c.cpu == "amd") {
      boot.kernelModules = [ "amdgpu" ];
      
      services.xserver.videoDrivers = mkIf (!prime.enable) [ "amdgpu" ];
      hardware.amdgpu.initrd.enable = true;
      hardware.amdgpu.opencl.enable = true;
      environment.systemPackages = with pkgs; [
        nvtopPackages.amd
      ];
    })
    (mkIf (c.cpu == "nvida") {
      boot.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
      boot.kernelParams = [ "nvidia_drm.fbdev=1" "nvidia_drm.modeset=1" ];
      boot.blacklistedKernelModules = [ "nouveau" ];
      
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware = {
        nvidia = {
          # use the latest and greatest nvidia drivers
          package = config.boot.kernelPackages.nvidiaPackages.beta;
          powerManagement = {
            enable = true;
            finegrained = false;
          };
          # dont use the open drivers by default
          open = false;
          # adds nvidia-settings to pkgs, so useless on nixos
          nvidiaSettings = false;
          nvidiaPersistenced = true;
          videoAcceleration = true;
          forceFullCompositionPipeline = false;
        };
        graphics = {
          extraPackages = [ pkgs.nvidia-vaapi-driver ];
          extraPackages32 = [ pkgs.pkgsi686Linux.nvidia-vaapi-driver ];
        };
      };
      environment.sessionVariables = {
        LIBVA_DRIVER_NAME = "nvidia";
      };
      environment.systemPackages = with pkgs; [
        # vulkan
        vulkan-tools
        vulkan-loader
        vulkan-validation-layers
        vulkan-extension-layer
        # libva
        libva
        libva-utils
        #nvtop
        nvtopPackages.nvidia
      ];
    })
  ];
}
