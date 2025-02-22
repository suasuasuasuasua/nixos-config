{ config, lib, ... }:
let
  serviceName = "nginx";

  cfg = config.services.custom.${serviceName};
in
{
  options.services.custom.${serviceName} = {
    enable = lib.mkEnableOption "Enable nginx";
  };

  config = lib.mkIf cfg.enable {
    services.nginx = {
      enable = true;
      recommendedTlsSettings = true;
      recommendedProxySettings = true;
      recommendedOptimisation = true;
    };
  };
}
