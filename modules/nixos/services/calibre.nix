{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "calibre";

  cfg = config.nixos.services.${serviceName};
in
{

  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Comprehensive e-book software
    '';
    serverPort = lib.mkOption {
      type = lib.types.port;
      default = 8080;
    };
    webPort = lib.mkOption {
      type = lib.types.port;
      default = 8083;
    };
    libraries = lib.mkOption {
      type = with lib.types; listOf path;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      calibre
    ];

    users.users = {
      calibre-server.extraGroups = [ "samba" ];
      calibre-web.extraGroups = [ "samba" ];
    };

    services = {
      calibre-server = {
        inherit (cfg) libraries;

        enable = true;
        port = cfg.serverPort;
      };

      calibre-web = {
        enable = true;
        listen = {
          ip = "127.0.0.1";
          port = cfg.webPort;
        };

        options = {
          # NOTE: kinda ugly but you can only access one library
          calibreLibrary = builtins.elemAt cfg.libraries 0;
          reverseProxyAuth = {
            enable = true;
            header = "${serviceName}.${hostName}.home";
          };
        };
      };
    };

    services.nginx.virtualHosts = {
      "${serviceName}.${hostName}.${domain}" = {
        enableACME = true;
        forceSSL = true;
        acmeRoot = null;
        locations."/" = {
          proxyPass = "http://localhost:${toString cfg.webPort}";
        };
      };
    };
  };
}
