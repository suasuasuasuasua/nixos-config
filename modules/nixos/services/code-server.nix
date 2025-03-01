{ config, lib, ... }:
let
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  inherit (config.networking) hostName;
  serviceName = "code-server";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption "Enable Code Server";
    port = lib.mkOption {
      type = lib.type.port;
      default = 4444;
    };
  };

  config = lib.mkIf cfg.enable {
    services.code-server = {
      inherit (cfg) port;

      enable = true;
      proxyDomain = "${serviceName}.${hostName}.home";

      user = "justinhoang";

      hashedPassword = "$argon2i$v=19$m=4096,t=3,p=1$E4memqjOEbshRXJOzjp+Jw$h459onElKavEl4t27b/XYRg+kJwfR9QSikk+spVGZkE";
      disableWorkspaceTrust = true;
      disableUpdateCheck = true;
      disableTelemetry = true;
      disableGettingStartedOverride = true;

      auth = "password";
    };

    services.nginx.virtualHosts = {
      "${serviceName}.${hostName}.home" = {
        locations."/" = {
          proxyPass = "http://localhost:${toString cfg.port}";
          proxyWebsockets = true; # needed if you need to use WebSocket

          extraConfig =
            # allow for larger file uploads like videos through the reverse proxy
            "client_max_body_size 0;";
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}
