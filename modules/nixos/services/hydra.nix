{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "hydra";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Cross-platform curses-based monitoring tool
    '';
    port = lib.mkOption {
      type = lib.types.port;
      default = 3004;
    };
  };

  config = lib.mkIf cfg.enable {
    services.hydra = {
      inherit (cfg) port;

      enable = true;
      package = pkgs.unstable.hydra;

      hydraURL = "https://${serviceName}.${hostName}.${domain}"; # externally visible URL
      notificationSender = "hydra@localhost"; # e-mail of hydra service
      # a standalone hydra will require you to unset the buildMachinesFiles list to avoid using a nonexistant /etc/nix/machines
      buildMachinesFiles = [ ];
      # you will probably also want, otherwise *everything* will be built from scratch
      useSubstitutes = true;
    };

    services.nginx.virtualHosts = {
      "${serviceName}.${hostName}.${domain}" = {
        enableACME = true;
        forceSSL = true;
        acmeRoot = null;

        locations."/" = {
          proxyPass = "http://localhost:${toString cfg.port}";

          extraConfig = ''
            proxy_set_header X-Forwarded-Port 443;
          '';
        };
      };
    };
  };
}
