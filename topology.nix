{ ... }:
{
  networks.home = {
    name = "Home";
    cidrv4 = "192.168.1.0/24";
  };

  # Example: declare a switch and connect hosts physically
  nodes.core-switch = {
    deviceType = "switch";
    interfaces = {
      swp1 = {};
      swp2 = {};
    };
  };
}
