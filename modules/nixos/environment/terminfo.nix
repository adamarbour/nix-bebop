{ pkgs, config, ...}:
let
  inherit (config.sys) isServer;
in {
  environment = {
    enableAllTerminfo = isServer;
    systemPackages = with pkgs; [
      ghostty.terminfo
      kitty.terminfo
    ];
  };
}
