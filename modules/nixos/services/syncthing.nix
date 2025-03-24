{
  config,
  lib,
  ...
}:
let
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  inherit (config.networking) hostName;
  serviceName = "syncthing";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption "Enable syncthing";
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
      # # TODO: do we need any settings for syncthing?
      # settings = { };
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
