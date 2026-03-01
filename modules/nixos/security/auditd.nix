{ lib, config, ...}:
let
  inherit (lib) mkIf mkEnableOption;
  c = config.sys.security.auditd;
in {
  options.sys.security.auditd = {
    enable = mkEnableOption "Enable the audit daemon";
  };
  
  config = mkIf (c.enable) {
    # start as early in the boot process as possible
    boot.kernelParams = ["audit=1"];

    security = {
      auditd = {
        enable = true;
        settings = {
          max_log_file = 250;
          max_log_file_action = "rotate";
          num_logs = 5;
        };
      };
      audit = {
        enable = true;
        backlogLimit = 8192;
        failureMode = "printk";
        rules = [
          "-w /etc/passwd -p wa -k identity"
          "-w /etc/group  -p wa -k identity"
          "-w /etc/shadow -p wa -k identity"
          "-w /etc/gshadow -p wa -k identity"
          "-w /etc/sudoers -p wa -k sudo"
          "-w /etc/sudoers.d -p wa -k sudo"
          "-w /etc/ssh -p wa -k ssh"
          
          "-a always,exit -F arch=b64 -S execve -F euid=0 -k exec_root"
          "-a always,exit -F arch=b64 -S setuid,setgid,setreuid,setregid,setresuid,setresgid -F auid>=1000 -F auid!=4294967295 -k setid"
          "-a always,exit -F arch=b64 -S init_module,finit_module,delete_module -k module_change"
        ];
      };
    };
  };
}
