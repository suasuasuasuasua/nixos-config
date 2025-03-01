{ config, lib, ... }:
let
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  inherit (config.networking) hostName;
  serviceName = "glances";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption "Enable Glances";
    port = lib.mkOption {
      type = lib.type.port;
      default = 61208;
    };
  };

  config = lib.mkIf cfg.enable {
    services.glances = {
      inherit (cfg) port;

      enable = true;
      openFirewall = true;
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
