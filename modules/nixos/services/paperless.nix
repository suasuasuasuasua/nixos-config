# sudo /var/lib/paperless/paperless-manage createsuperuser
{ config, lib, ... }:
let
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  hostName = config.networking.hostName;
  serviceName = "paperless";
  # default port is 28981
  port = 28981;

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption "Enable Paperless";
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      port
    ];

    services.paperless = {
      enable = true;
      port = port;
      mediaDir = "/zshare/personal/docs";

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
          # Expose the second port for the web interface!
          proxyPass = "http://localhost:${toString port}";
          proxyWebsockets = true; # needed if you need to use WebSocket

          extraConfig =
            # allow for larger file uploads like videos through the reverse proxy
            "client_max_body_size 0;";
        };
      };
    };
  };
}
