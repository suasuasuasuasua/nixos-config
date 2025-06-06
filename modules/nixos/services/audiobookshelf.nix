{ config, lib, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "audiobookshelf";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Self-hosted audiobook and podcast server
    '';
    port = lib.mkOption {
      type = lib.types.port;
      default = 8000;
    };
  };

  config = lib.mkIf cfg.enable {
    services.audiobookshelf = {
      inherit (cfg) port;

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
        };
      };
    };
  };
}
