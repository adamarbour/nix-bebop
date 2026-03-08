{ lib }:
let
  inherit (lib) any elem filter hasAttr getAttrFromPath;
in {
  # check if the group exists before adding it to the user...
  groupExist = config: groups:
    filter (group: hasAttr group config.users.groups) groups;
  
  # check if the system has a particular role
  hasRole = config: role:
    builtins.elem role (config.sys.roles or []);
    
  # check condition in home-manager
  anyHome = conf: cond:
    let
      list = map (user: getAttrFromPath [ "home-manager" "users" user ] conf) conf.sys.users;
    in
    any cond list;
}
