{ config, lib, ... }:
let
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  inherit (config.networking) hostName;
  serviceName = "ollama";
  port1 = 11434;
  port2 = 8080;

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption "Enable Ollama";
    open-webui.enable = lib.mkEnableOption "Enable Open WebUI";

    acceleration = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          false
          "rocm"
          "cuda"
        ]
      );
      default = null;
      example = "rocm";
      description = ''
        What interface to use for hardware acceleration.

        - `null`: default behavior
          - if `nixpkgs.config.rocmSupport` is enabled, uses `"rocm"`
          - if `nixpkgs.config.cudaSupport` is enabled, uses `"cuda"`
          - otherwise defaults to `false`
        - `false`: disable GPU, only use CPU
        - `"rocm"`: supported by most modern AMD GPUs
          - may require overriding gpu type with `services.ollama.rocmOverrideGfx`
            if rocm doesn't detect your AMD gpu
        - `"cuda"`: supported by most modern NVIDIA GPUs
      '';
    };
  };

  config = {
    # Enable the ollama LLM backend
    services = {
      ollama = lib.mkIf cfg.enable {
        enable = true;
        inherit (cfg) acceleration;
        host = "127.0.0.1";
        port = port1;
      };

      # Enable the web interface
      open-webui = lib.mkIf cfg.open-webui.enable {
        enable = true;
        host = "127.0.0.1";
        port = port2;
      };

      nginx.virtualHosts = {
        "${serviceName}.${hostName}.home" = {
          locations."/" = {
            # Expose the second port for the web interface!
            proxyPass = "http://localhost:${toString port2}";
          };
        };
      };
    };
  };
}
