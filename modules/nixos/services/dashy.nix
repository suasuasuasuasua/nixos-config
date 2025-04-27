{
  config,
  options,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.networking) hostName;
  serviceName = "dashy";

  cfg = config.nixos.services.${serviceName};
  opt = options.nixos.services.${serviceName};

  # types
  jsonFormat = pkgs.formats.json { };

  settings = with lib; opt.settings.default // optionalAttrs (cfg.settings != { }) cfg.settings;
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      dashy
    '';
    settings = lib.mkOption {
      inherit (jsonFormat) type;
      default = {
        # appConfig = {
        #   enableFontAwesome = true;
        #   fontAwesomeKey = "e9076c7025";
        #   layout = "auto";

        #   theme = "basic";
        # };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.dashy = {
      inherit settings;

      enable = true;
      virtualHost.enableNginx = true;
      virtualHost.domain = "${serviceName}.${hostName}.home";
    };
  };
}
