{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "open-webui";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Comprehensive suite for LLMs with a user-friendly WebUI
    '';
    port = lib.mkOption {
      type = lib.types.port;
      default = 8082;
    };
  };

  config = lib.mkIf cfg.enable {
    services.open-webui = {
      # Enable the web interface
      inherit (cfg) port;

      package = pkgs.unstable.open-webui;

      enable = true;
      host = "127.0.0.1";
    };

    services.nginx.virtualHosts = {
      "${serviceName}.${hostName}.${domain}" = {
        enableACME = true;
        forceSSL = true;
        acmeRoot = null;
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
