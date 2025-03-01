{ config, lib, ... }:
let
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  inherit (config.networking) hostName;
  serviceName = "open-webui";
  port = 8080;

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption "Enable Open WebUI";
  };

  config = {
    # Enable the ollama LLM backend
    services = {
      # Enable the web interface
      open-webui = lib.mkIf cfg.open-webui.enable {
        inherit port;
        enable = true;
        host = "127.0.0.1";
      };

      nginx.virtualHosts = {
        "${serviceName}.${hostName}.home" = {
          locations."/" = {
            # Expose the second port for the web interface!
            proxyPass = "http://localhost:${toString port}";
          };
        };
      };
    };
  };
}
