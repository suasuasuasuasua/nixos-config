{ config, lib, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "miniflux";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Minimalist and opinionated feed reader
    '';
    port = lib.mkOption {
      type = lib.types.port;
      default = 9001;
    };
    adminCredentialsFile = lib.mkOption {
      type = lib.types.path;
    };
  };

  config = lib.mkIf cfg.enable {
    services.miniflux = {
      inherit (cfg) adminCredentialsFile;

      enable = true;
      config = {
        PORT = cfg.port;
      };
    };

    services.nginx.virtualHosts = {
      "${serviceName}.${hostName}.${domain}" = {
        enableACME = true;
        forceSSL = true;
        acmeRoot = null;
        locations."/" = {
          proxyPass = "http://localhost:${toString cfg.port}";
        };
      };
    };
  };
}
