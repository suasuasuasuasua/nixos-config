{ config, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "paperless";

  port = 28981;
  mediaDir = "/zshare/personal/docs";
in
{
  # sudo /var/lib/paperless/paperless-manage createsuperuser
  users.users.paperless.extraGroups = [ "samba" ];

  services.paperless = {
    inherit port mediaDir;

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

      # https://github.com/paperless-ngx/paperless-ngx/wiki/Using-a-Reverse-Proxy-with-Paperless-ngx#
      PAPERLESS_URL = "https://${serviceName}.${domain}";
      PAPERLESS_CSRF_TRUSTED_ORIGINS = "https://${serviceName}.${domain}";
      PAPERLESS_USE_X_FORWARD_HOST = true;
      PAPERLESS_USE_X_FORWARD_PORT = true;
      PAPERLESS_PROXY_SSL_HEADER = [
        "HTTP_X_FORWARDED_PROTO"
        "https"
      ];
    };
  };

  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString port}";
        proxyWebsockets = true; # needed if you need to use WebSocket

        extraConfig =
          # allow for larger file uploads like videos through the reverse proxy
          "client_max_body_size 0;";
      };

      serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
    };
  };
}
