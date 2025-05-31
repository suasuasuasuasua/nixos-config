{ config, lib, ... }:
let
  inherit (config.networking) hostName;
  serviceName = "glances";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Cross-platform curses-based monitoring tool
    '';
    port = lib.mkOption {
      type = lib.types.port;
      default = 61208;
    };
  };

  config = lib.mkIf cfg.enable {
    services.glances = {
      inherit (cfg) port;

      enable = true;
      extraArgs = [
        "--webserver"
      ];
    };

    services.nginx.virtualHosts = {
      "${serviceName}.${hostName}.home" = {
        locations."/" = {
          proxyPass = "http://localhost:${toString cfg.port}";
        };
      };
    };
  };
}
