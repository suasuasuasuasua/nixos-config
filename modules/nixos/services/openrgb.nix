{ config, lib, ... }:
let
  serviceName = "openrgb";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption "Enable Open WebUI";
    port = lib.mkOption {
      type = lib.types.port;
      default = 6742;
    };
    motherboard = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          false
          "amd"
          "intel"
        ]
      );
      default = null;
      example = "intel";
    };
  };

  config = lib.mkIf cfg.enable {
    services.hardware.openrgb = {
      inherit (cfg) motherboard;

      enable = true;
      server = {
        inherit (cfg) port;
      };
    };
  };
}
