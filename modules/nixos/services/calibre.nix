{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  hostName = config.networking.hostName;

  # default port = 8083
  port = 8083;
  serviceName = "calibre";

  cfg = config.services.custom.${serviceName};
in
{

  options.services.custom.${serviceName} = {
    enable = lib.mkEnableOption "Enable calibre EBook Manager";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.calibre
    ];

    services.calibre-server = {
      enable = true;
      openFirewall = true;
      libraries = [
        "/zshare/media/books/ebooks/"
      ];
    };

    services.calibre-web = {
      enable = true;
      listen = {
        port = port;
        ip = "127.0.0.1";
      };
      openFirewall = true;

      options = {
        calibreLibrary = "/zshare/media/books/ebooks/";
        reverseProxyAuth = {
          enable = true;
          header = "${serviceName}.${hostName}.home";
        };
      };
    };

    services.nginx.virtualHosts = {
      "${serviceName}.${hostName}.home" = {
        locations."/" = {
          # audiobook manager
          proxyPass = "http://localhost:${toString port}";
        };
      };
    };
  };
}
