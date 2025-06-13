{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixos.development.cli;
in
{
  options.nixos.development.virtualization = {
    enable = lib.mkEnableOption "Enable virtualization tools";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = false;

      # https://wiki.nixos.org/wiki/Docker#Rootless_Docker
      rootless = {
        enable = true;
        setSocketVariable = true;
        # Optionally customize rootless Docker daemon settings
        daemon.settings = {
          dns = [
            "1.1.1.1"
            "8.8.8.8"
          ];
          registry-mirrors = [ "https://mirror.gcr.io" ];
        };
      };
    };

    environment.systemPackages = with pkgs; [ lazydocker ];
  };
}
