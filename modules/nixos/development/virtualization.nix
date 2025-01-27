{ pkgs, ... }:
{
  # Enable docker
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  environment.systemPackages = with pkgs; [ lazydocker ];
}
