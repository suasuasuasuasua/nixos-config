# https://wiki.nixos.org/wiki/Nginx
{ config, ... }:
let
  inherit (config.networking) domain;
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
        "/" = {
          return = ''
            200 '<html><body>Hello World!</body></html>'
          '';
          extraConfig = ''
            add_header Content-Type text/html;
          '';
        };
        "/iso" = {
          root = "/zshare/srv/";
          extraConfig = ''
            autoindex on;
            sendfile on;
            sendfile_max_chunk 1m;
            sendfile on;
            tcp_nopush on;
            tcp_nodelay on;
            keepalive_timeout 65;
          '';
        };
        "/blog" = {
          root = "/var/www/";
          extraConfig = ''
            autoindex on;
            sendfile on;
            sendfile_max_chunk 1m;
            sendfile on;
            tcp_nopush on;
            tcp_nodelay on;
            keepalive_timeout 65;
          '';
        };
        # expose the ip address of the machine
        "/ip" = {
          return = ''
            200 '{"host":"$server_name","ip":"$remote_addr","port":"$remote_port","server_ip":"$server_addr","server_port":"$server_port"}\n'
          '';
          extraConfig = ''
            add_header Content-Type "application/json";
          '';
        };
      };
    };
  };

  users.users.nginx.extraGroups = [ "samba" ];
}
