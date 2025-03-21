{
  flake,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (flake) inputs;
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  inherit (config.networking) hostName;
  serviceName = "actual";

  cfg = config.nixos.services.${serviceName};
in
{
  imports = [
    "${inputs.nixpkgs-unstable}/nixos/modules/services/web-apps/actual.nix"
  ];

  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption "Enable Actual Budget";
    port = lib.mkOption {
      type = lib.types.port;
      default = 3001;
    };
  };

  config = lib.mkIf cfg.enable {
    # TODO: need to setup HTTPS to continue using...
    services.actual = {
      enable = true;
      package = pkgs.unstable.actual-server;
      openFirewall = true;
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
