{ _class, ... }:
{
  _class = "nixos";
  
  imports = [
    # keep-sorted start
    ./common
    ./nixos
    # keep-sorted end
  ];
}
