{
  config,
  lib,
  ...
}:
let
  inherit (config.networking) hostName;
  serviceName = "actual";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Super fast privacy-focused app for managing your finances
    '';
    port = lib.mkOption {
      type = lib.types.port;
      default = 3001;
    };
  };

  config = lib.mkIf cfg.enable {
    # TODO: need to setup HTTPS to continue using...
    services.actual = {
      enable = true;
      settings = {
        inherit (cfg) port;
      };
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
