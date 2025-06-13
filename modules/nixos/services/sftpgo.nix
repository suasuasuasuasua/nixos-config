{
  config,
  lib,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "sftpgo";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Fully featured and highly configurable SFTP server
    '';
  };

  config = lib.mkIf cfg.enable {
    services.sftpgo = {
      enable = true;
      group = "samba";

      # TODO: modularize!
      dataDir = "/zshare";
      settings = {
        httpd.bindings = [
          {
            port = 8084;
            enable_web_client = true;
            enable_web_admin = true;
            address = "127.0.0.1";
          }
        ];
        sftpd.bindings = [ ];
        ftpd.bindings = [ ];
      };
    };

    services.nginx.virtualHosts = {
      "${serviceName}.${hostName}.${domain}" = {
        enableACME = true;
        forceSSL = true;
        acmeRoot = null;
        locations."/" = {
          # TODO: modularize!
          proxyPass = "http://localhost:8084";
        };
      };
    };
  };
}
