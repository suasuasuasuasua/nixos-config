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
    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/syncthing";
    };
    group = lib.mkOption {
      type = lib.types.str;
      default = "syncthing";
    };
    user = lib.mkOption {
      type = lib.types.str;
      default = "syncthing";
    };
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
      inherit (cfg)
        dataDir
        group
        user
        settings
        ;

      enable = true;

      # 0.0.0.0 for debugging from web gui
      guiAddress = "127.0.0.1:${toString cfg.port}";
      openDefaultPorts = true;
      overrideDevices = true;
      overrideFolders = true;
    };

    # https://wiki.nixos.org/wiki/Syncthing#Disable_default_sync_folder
    # don't create the default folder
    systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";

    services.nginx.virtualHosts = {
      "${serviceName}.${hostName}.home" = {
        locations."/" = {
          proxyPass = "http://localhost:${toString cfg.port}";
        };
      };
    };
  };
}
