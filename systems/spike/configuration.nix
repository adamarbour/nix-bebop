{
  sys.users = [ "adam" ];
  sys.secrets.enable = false;
  
  sys.boot = {
    efi.enable = true;
    secureBoot.enable = false;
  };
}
