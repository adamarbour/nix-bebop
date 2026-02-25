{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.sys.services.openssh;
in {
  options.sys.services.openssh = {
    enable = mkEnableOption "enable openssh service" // { default = true; };
  };
  
  config = mkIf (c.enable) {
    sys.persist.storage.files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
    services.openssh = {
      enable = true;
      allowSFTP = true;
      openFirewall = true;
      ports = [ 22 ];
      settings = {
        # Don't allow root login
        PermitRootLogin = "no";

        AuthenticationMethods = "publickey";
        PubkeyAuthentication = "yes";
        PasswordAuthentication = false;
        PermitEmptyPasswords = false;
        PermitTunnel = false;
        UseDns = false;
        ChallengeResponseAuthentication = "no";
        KbdInteractiveAuthentication = false;
        X11Forwarding = false;
        MaxAuthTries = 3;
        MaxSessions = 2;
        TCPKeepAlive = false;
        AllowTcpForwarding = false;
        AllowAgentForwarding = false;
        LogLevel = "VERBOSE";
        
        # kick out inactive sessions
        ClientAliveCountMax = 5;
        ClientAliveInterval = 60;
        
        LoginGraceTime = 30;
        MaxStartups = "10:30:60";
        
        KexAlgorithms = [
          "curve25519-sha256"
          "curve25519-sha256@libssh.org"
        ];
        Ciphers = [
          "chacha20-poly1305@openssh.com"
          "aes256-gcm@openssh.com"
          "aes128-gcm@openssh.com"
        ];
      };
      hostKeys = [
        {
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };
  };
}
