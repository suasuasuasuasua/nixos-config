# sudo /var/lib/paperless/paperless-manage createsuperuser
{ config, ... }:
let
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  hostName = config.networking.hostName;
  serviceName = "paperless";
  # default port is 28981
  port = 28981;
in
{
  networking.firewall.allowedTCPPorts = [
    port
  ];

  services.paperless = {
    enable = true;
    port = port;
    mediaDir = "/zshare/personal/docs";

    consumptionDirIsPublic = true;
    address = "paperless.lab.home";
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
      };
    };
  };
}
