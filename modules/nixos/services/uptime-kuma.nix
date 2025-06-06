{
  config,
  lib,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "uptime-kuma";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Fany self-hosted monitoring tool
    '';
    port = lib.mkOption {
      type = lib.types.port;
      default = 3002;
    };
  };

  config = lib.mkIf cfg.enable {
    services.uptime-kuma = {
      enable = true;

      appriseSupport = true;
      settings = {
        UPTIME_KUMA_PORT = builtins.toString cfg.port;
      };
    };

    services.nginx.virtualHosts = {
      "${serviceName}.${hostName}.${domain}" = {
        enableACME = true;
        forceSSL = true;
        acmeRoot = null;
        locations."/" = {
          proxyPass = "http://localhost:${toString cfg.port}";
          proxyWebsockets = true; # needed if you need to use WebSocket
        };
      };
    };
  };
}
