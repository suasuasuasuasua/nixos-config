{ config, lib, ... }:
let
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  hostName = config.networking.hostName;
  serviceName = "ollama";
  port1 = 11434;
  port2 = 8080;

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption "Enable Ollama and Open WebUI";

    # TODO: add acceleration as an option
  };

  config = lib.mkIf cfg.enable {
    # Enable the ollama LLM backend
    services.ollama = {
      enable = true;
      # TODO: make this acceleration type an option
      # acceleration = "cuda";
      host = "127.0.0.1";
      port = port1;
    };

    # Enable the web interface
    services.open-webui = {
      enable = true;
      host = "127.0.0.1";
      port = port2;
    };

    services.nginx.virtualHosts = {
      "${serviceName}.${hostName}.home" = {
        locations."/" = {
          # Expose the second port for the web interface!
          proxyPass = "http://localhost:${toString port2}";
        };
      };
    };
  };
}
