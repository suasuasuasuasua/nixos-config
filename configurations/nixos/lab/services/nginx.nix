# https://wiki.nixos.org/wiki/Nginx
{ config, ... }:
let
  inherit (config.networking) domain;

  fileServeConfig = ''
    autoindex on;
    sendfile on;
    sendfile_max_chunk 1m;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
  '';
in
{
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
  };

  services.nginx.virtualHosts = {
    "${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations = {
        "/blog" = {
          root = "/var/www/";
          extraConfig = fileServeConfig;
        };
        "/ip" = {
          # expose the ip address of the machine
          return = ''
            200 '{"host":"$server_name","ip":"$remote_addr","port":"$remote_port","server_ip":"$server_addr","server_port":"$server_port"}\n'
          '';
          extraConfig = ''
            add_header Content-Type "application/json";
          '';
        };
        "/iso" = {
          root = "/zshare/srv/";
          extraConfig = fileServeConfig;
        };
        "/" = {
          return = ''
            200 '<html><body>Hello World!</body></html>'
          '';
          extraConfig = ''
            add_header Content-Type text/html;
          '';
        };
      };
    };
  };

  users.users.nginx.extraGroups = [ "samba" ];
}
