# https://wiki.nixos.org/wiki/Hydra
# a tool for continuous integration testing software release
{ config, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "hydra";

  # default = 3000
  port = 3002;
in
{
  services.hydra = {
    inherit port;

    enable = true;

    hydraURL = "https://${serviceName}.${domain}"; # externally visible URL
    notificationSender = "hydra@localhost"; # e-mail of hydra service
    # a standalone hydra will require you to unset the buildMachinesFiles list to avoid using a nonexistant /etc/nix/machines
    buildMachinesFiles = [ ];
    # you will probably also want, otherwise *everything* will be built from scratch
    useSubstitutes = true;
  };

  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString port}";

        extraConfig = ''
          proxy_set_header X-Forwarded-Port 443;
        '';
      };

      serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
    };
  };
}
