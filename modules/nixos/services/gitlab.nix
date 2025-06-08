{
  config,
  lib,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "gitlab";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      GitLab Community Edition
    '';
    databasePasswordFile = lib.mkOption {
      type = lib.types.path;
    };
    initialRootPasswordFile = lib.mkOption {
      type = lib.types.path;
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 8084;
    };
    secrets = {
      secretFile = lib.mkOption {
        type = lib.types.path;
      };
      otpFile = lib.mkOption {
        type = lib.types.path;
      };
      jwsFile = lib.mkOption {
        type = lib.types.path;
      };
      dbFile = lib.mkOption {
        type = lib.types.path;
      };
      activeRecordSaltFile = lib.mkOption {
        type = lib.types.path;
      };
      activeRecordPrimaryKeyFile = lib.mkOption {
        type = lib.types.path;
      };
      activeRecordDeterministicKeyFile = lib.mkOption {
        type = lib.types.path;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      gitlab = {
        inherit (cfg)
          databasePasswordFile
          initialRootPasswordFile
          port
          secrets
          ;

        enable = true;
        initialRootEmail = "admin@local.host";
        https = true;
        host = "${serviceName}.${hostName}.${domain}";
      };
      openssh.enable = true;
    };

    services.nginx.virtualHosts = {
      "${serviceName}.${hostName}.${domain}" = {
        enableACME = true;
        forceSSL = true;
        acmeRoot = null;
        locations."/" = {
          proxyPass = "http://unix:/run/gitlab/gitlab-workhorse.socket";
        };
      };
    };

    systemd.services.gitlab-backup.environment.BACKUP = "dump";
  };
}
