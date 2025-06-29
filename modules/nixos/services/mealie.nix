{ config, lib, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "mealie";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Self hosted recipe manager and meal planner
    '';
    port = lib.mkOption {
      type = lib.types.port;
      default = 9000;
    };
  };

  config = lib.mkIf cfg.enable {
    services.mealie = {
      inherit (cfg) port;

      enable = true;
      settings = { };
    };

    services.nginx.virtualHosts = {
      "${serviceName}.${hostName}.${domain}" = {
        enableACME = true;
        forceSSL = true;
        acmeRoot = null;
        locations."/" = {
          proxyPass = "http://localhost:${toString cfg.port}";
        };
      };
    };
  };
}
