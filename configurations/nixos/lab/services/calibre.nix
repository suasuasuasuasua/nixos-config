# calibre is a self hosted e-book manager
{
  inputs,
  config,
  pkgs,
  infra,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "calibre";

  libraries = [ "/zshare/media/books/ebooks/" ];
in

{
  services = {
    calibre-server = {
      inherit libraries;
      port = infra.ports.calibre.server;

      enable = true;
    };

    calibre-web = {
      enable = true;

      # https://github.com/NixOS/nixpkgs/issues/503251
      package = inputs.nixpkgs-calibre-web.legacyPackages.${pkgs.stdenv.hostPlatform.system}.calibre-web;
      listen = {
        port = infra.ports.calibre.web;

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
        proxyPass = "http://127.0.0.1:${toString infra.ports.calibre.web}";
      };

      serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
    };
  };

  environment.systemPackages = [ pkgs.calibre ];
}
