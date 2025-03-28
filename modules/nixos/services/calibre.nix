{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.networking) hostName;
  serviceName = "calibre";

  cfg = config.nixos.services.${serviceName};
in
{

  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Comprehensive e-book software
    '';
    port = lib.mkOption {
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

    services = {
      calibre-server = {
        inherit (cfg) libraries;

        enable = true;
        openFirewall = true;
      };

      calibre-web = {
        enable = true;
        listen = {
          inherit (cfg) port;

          ip = "127.0.0.1";
        };
        openFirewall = true;

        options = {
          # TODO: kinda ugly but you can only access one library
          calibreLibrary = builtins.elemAt cfg.libraries 0;
          reverseProxyAuth = {
            enable = true;
            header = "${serviceName}.${hostName}.home";
          };
        };
      };

      nginx.virtualHosts = {
        "${serviceName}.${hostName}.home" = {
          locations."/" = {
            proxyPass = "http://localhost:${toString cfg.port}";
          };
        };
      };
    };
  };
}
