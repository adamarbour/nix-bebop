{ sources ? import ./lon.nix }:
final: prev:
let
  cachyosKernels = import sources.nix-cachyos-kernel;
  upstreamOverlay = cachyosKernels.overlays.default;
in upstreamOverlay final prev
