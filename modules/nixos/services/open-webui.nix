{ config, lib, ... }:
let
  inherit (config.networking) hostName;
  serviceName = "open-webui";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Comprehensive suite for LLMs with a user-friendly WebUI
    '';
    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
    };
  };

  config = lib.mkIf cfg.enable {
    services.open-webui = {
      # Enable the web interface
      inherit (cfg) port;

      enable = true;
      host = "127.0.0.1";
    };

    services.nginx.virtualHosts = {
      "${serviceName}.${hostName}.home" = {
        locations."/" = {
          # Expose the second port for the web interface!
          proxyPass = "http://localhost:${toString cfg.port}";
        };
      };
    };
  };
}
