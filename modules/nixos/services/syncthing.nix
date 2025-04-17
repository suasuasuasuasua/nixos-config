{
  config,
  lib,
  ...
}:
let
  inherit (config.networking) hostName;
  serviceName = "syncthing";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Open Source Continuous File Synchronization
    '';
    port = lib.mkOption {
      type = lib.types.port;
      default = 8384;
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];

    services.syncthing = {
      enable = true;

      guiAddress = "http://localhost:${toString cfg.port}";
      openDefaultPorts = true;
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
