{ config, lib, ... }:
let
  serviceName = "nginx";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Reverse proxy and lightweight webserver
    '';
  };

  config = lib.mkIf cfg.enable {
    services.nginx = {
      enable = true;
      recommendedTlsSettings = true;
      recommendedProxySettings = true;
      recommendedOptimisation = true;
    };

    services.nginx.virtualHosts = {
      # expose the ip address of the machine
      "127.0.0.1" = {
        locations."/ip" = {
          extraConfig = ''
            add_header Content-Type "application/json";
          '';
          return = ''
            200 '{"host":"$server_name","ip":"$remote_addr","port":"$remote_port","server_ip":"$server_addr","server_port":"$server_port"}\n'
          '';
        };
      };
    };
  };
}
