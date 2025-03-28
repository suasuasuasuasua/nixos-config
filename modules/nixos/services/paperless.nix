# sudo /var/lib/paperless/paperless-manage createsuperuser
{ config, lib, ... }:
let
  inherit (config.networking) hostName;
  serviceName = "paperless";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Tool to scan, index, and archive all of your physical documents
    '';
    port = lib.mkOption {
      type = lib.types.port;
      default = 28981;
    };
    mediaDir = lib.mkOption {
      type = lib.types.path;
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      cfg.port
    ];

    services.paperless = {
      inherit (cfg) port mediaDir;

      enable = true;
      consumptionDirIsPublic = true;
      settings = {
        PAPERLESS_CONSUMER_IGNORE_PATTERN = [
          ".DS_STORE/*"
          "desktop.ini"
        ];
        PAPERLESS_OCR_LANGUAGE = "deu+eng";
        PAPERLESS_OCR_USER_ARGS = {
          optimize = 1;
          pdfa_image_compression = "lossless";
        };
      };
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
