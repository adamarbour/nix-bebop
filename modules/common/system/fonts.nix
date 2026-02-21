{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    corefonts
    vista-fonts
    
    source-sans
    source-serif
    
    liberation_ttf
    dejavu_fonts
    inter
    
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    
    material-icons
    material-design-icons
    
    nerd-fonts.symbols-only
    nerd-fonts.jetbrains-mono
  ];
}
