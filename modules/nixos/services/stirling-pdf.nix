{
  config,
  lib,
  ...
}:
let
  inherit (config.networking) hostName;
  serviceName = "stirling-pdf";

  cfg = config.nixos.services.${serviceName};

  environment = {
    SERVER_PORT = cfg.port;
    SYSTEM_ENABLEANALYTICS = "false";
  };
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Locally hosted web application that allows you to perform various operations on PDF files
    '';
    port = lib.mkOption {
      type = lib.types.port;
      default = 8081;
    };
  };

  config = lib.mkIf cfg.enable {
    services.stirling-pdf = {
      inherit environment;

      enable = true;
    };

    services.nginx.virtualHosts = {
      "${serviceName}.${hostName}.home" = {
        locations."/" = {
          proxyPass = "http://localhost:${toString cfg.port}";
          proxyWebsockets = true; # needed if you need to use WebSocket

          extraConfig =
            # allow for larger file uploads like videos through the reverse proxy
            "client_max_body_size 0;";
        };
      };
    };
  };
}
