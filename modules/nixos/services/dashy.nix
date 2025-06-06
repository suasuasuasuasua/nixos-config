{
  config,
  options,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "dashy";

  cfg = config.nixos.services.${serviceName};
  opts = options.nixos.services.${serviceName};

  # types
  jsonFormat = pkgs.formats.json { };

  settings = with lib; opts.settings.default // optionalAttrs (cfg.settings != { }) cfg.settings;
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      dashy
    '';
    settings = lib.mkOption {
      inherit (jsonFormat) type;
      default = {
        appConfig = {
          enableFontAwesome = true;
          fontAwesomeKey = "e9076c7025";
          layout = "auto";

          theme = "basic";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.dashy = {
      inherit settings;

      enable = true;
      virtualHost.enableNginx = true;
      virtualHost.domain = "${hostName}.${domain}";
    };

    # Add SSL
    services.nginx.virtualHosts = {
      "${hostName}.${domain}" = {
        enableACME = true;
        forceSSL = true;
        acmeRoot = null;

        serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
      };
    };
  };
}
