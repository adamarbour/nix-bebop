{ lib, pkgs, config, ...}:
let
  inherit (lib) types mkOption mkEnableOption mkIf mkForce;
  c = config.sys.hw.prime;
  gpu = config.sys.hw.gpu;
in {
  options.sys.hw.prime = {
    enable = mkEnableOption "enable prime (nvidia) support";
    nvidiaBusId = mkOption {
      type = types.str;
      description = "NVIDIA dGPU Bus ID (PCI:B:D:F).";
    };
    iGpuBusId = mkOption {
      type = types.str;
      description = "iGpu Bus ID (PCI:B:D:F).";
    };
    mode = mkOption {
      type = types.enum [ "offload" "sync" ];
      default = "offload";
      description = ''
        PRIME mode:
          - offload: iGPU renders by default; run apps on dGPU explicitly.
          - sync: dGPU renders everything; higher power usage.
      '';
    };
    dynamicBoost = mkOption {
      type = types.bool;
      default = false;
      description = "enable dynamic Boost balances power between the CPU and the GPU.";
    };
    finegrainedPM = mkOption {
      type = types.bool;
      default = false;
      description = "enable experimental power management of PRIME offload.";
    };
  };
  
  config = mkIf (c.enable) {
    boot.blacklistedKernelModules = [ "nouveau" ];
    services.xserver.videoDrivers = mkForce [ "nvidia" ];
    
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
    
    hardware.nvidia = {
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      
      prime = {
        nvidiaBusId = c.prime.nvidiaBusId;
        intelBusId = mkIf (gpu == "intel") c.prime.iGpuBusId;
        amdgpuBusId = mkIf (gpu == "amd") c.prime.iGpuBusId;
        
        offload.enable = c.prime.mode == "offload";
        offload.enableOffloadCmd = c.prime.mode == "offload";
        sync.enable = c.prime.mode == "sync";
      };
      dynamicBoost.enable = c.prime.dynamicBoost;
      powerManagement = {
        enable = true;
        finegrained = c.prime.finegrainedPM;
      };
      # dont use the open drivers by default
      open = false;
      # adds nvidia-settings to pkgs, so useless on nixos
      nvidiaSettings = false;
      nvidiaPersistenced = true;
      videoAcceleration = true;
      forceFullCompositionPipeline = false;
    };
    
    hardware.graphics = {
      extraPackages = [ pkgs.nvidia-vaapi-driver ];
      extraPackages32 = [ pkgs.pkgsi686Linux.nvidia-vaapi-driver ];
    };
  };
}
