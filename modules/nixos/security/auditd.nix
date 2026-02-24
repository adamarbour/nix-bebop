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
          "-w /etc/passwd -p wa -k passwd_changes"
          "-w /etc/shadow -p wa -k shadow_changes"
          "-w /etc/sudoers -p wa -k sudo_changes"
          "-w /etc/ssh/sshd_config -p wa -k ssh_changes"
          "-w /etc/pam.d/ -p wa -k pam_changes"
          "-w /sbin/insmod -p x -k module_insertion"
          "-w /sbin/modprobe -p x -k module_insertion"
          "-a always,exit -F arch=b64 -S execve -k exec_log"
          "-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time_change"
          "-e 2"
        ];
      };
    };
  };
}
