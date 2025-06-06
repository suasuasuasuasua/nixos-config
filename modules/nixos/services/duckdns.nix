{
  config,
  lib,
  ...
}:
let
  serviceName = "duckdns";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Free dynamic dns
    '';
    domains = lib.mkOption {
      type = with lib.types; nullOr (listOf str);
    };
    tokenFile = lib.mkOption {
      type = lib.types.path;
    };
  };

  config = lib.mkIf cfg.enable {
    services.duckdns = {
      inherit (cfg) domains tokenFile;

      enable = true;
    };
  };
}
