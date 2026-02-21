{ lib }:
let
  inherit (lib) elem filter hasAttr;
in {
  # check if the group exists before adding it to the user...
  groupExist = config: groups:
    filter (group: hasAttr group config.users.groups) groups;
  
  # check if the system has a particular role
  hasRole = config: role:
    builtins.elem role (config.sys.roles or []);
}
