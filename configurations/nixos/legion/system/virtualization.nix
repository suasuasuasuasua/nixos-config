{ pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;

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
}
