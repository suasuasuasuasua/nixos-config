{
  config,
  lib,
  pkgs,
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
    settings = lib.mkOption {
      inherit (pkgs.formats.json { }) type;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];

    services.syncthing = {
      inherit (cfg) settings;

      enable = true;

      # 0.0.0.0 for debugging from web gui
      guiAddress = "0.0.0.0:${toString cfg.port}";
      openDefaultPorts = true;
      overrideDevices = true;
      overrideFolders = true;
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
