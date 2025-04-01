{ config, lib, ... }:
let
  serviceName = "nginx";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Reverse proxy and lightweight webserver
    '';
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
