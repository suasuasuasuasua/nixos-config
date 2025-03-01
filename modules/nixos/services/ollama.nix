{ config, lib, ... }:
let
  serviceName = "ollama";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption "Enable Ollama";
    port = lib.mkOption {
      type = lib.types.port;
      default = 11434;
    };
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
    services = {
      ollama = lib.mkIf cfg.enable {
        inherit (cfg) port acceleration;

        enable = true;
        host = "127.0.0.1";
      };
    };
  };
}
