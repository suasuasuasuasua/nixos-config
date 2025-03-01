{ config, lib, ... }:
let
  serviceName = "ollama";
  port = 11434;

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
        inherit port;
        enable = true;
        inherit (cfg) acceleration;
        host = "127.0.0.1";
      };
    };
  };
}
