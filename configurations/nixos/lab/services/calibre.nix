# calibre is a self hosted e-book manager
{
  config,
  pkgs,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "calibre";

  libraries = [ "/zshare/media/books/ebooks/" ];
  port = {
    server = 8080;
    web = 8083;
  };
in

{
  users.users = {
    calibre-server.extraGroups = [ "samba" ];
    calibre-web.extraGroups = [ "samba" ];
  };

  services = {
    calibre-server = {
      inherit libraries;

      enable = true;
      port = port.server;
    };

    calibre-web = {
      enable = true;
      listen = {
        ip = "127.0.0.1";
        port = port.web;
      };

      options = {
        # NOTE: kinda ugly but you can only access one library
        calibreLibrary = builtins.elemAt libraries 0;
        reverseProxyAuth = {
          enable = true;
          header = "${serviceName}.${domain}";
        };
      };
    };
  };

  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString port.web}";
      };

      serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
    };
  };

  environment.systemPackages = [ pkgs.calibre ];
}
