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
  server.port = 8080;
  web.port = 8083;
in

{
  services = {
    calibre-server = {
      inherit libraries;
      inherit (server) port;

      enable = true;
    };

    calibre-web = {
      enable = true;
      listen = {
        inherit (web) port;

        ip = "127.0.0.1";
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

  users.users = {
    calibre-server.extraGroups = [ "samba" ];
    calibre-web.extraGroups = [ "samba" ];
  };

  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString web.port}";
      };

      serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
    };
  };

  environment.systemPackages = [ pkgs.calibre ];
}
