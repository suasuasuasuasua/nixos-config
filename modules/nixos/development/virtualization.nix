{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.development.cli;
in
{
  options.development.virtualization = {
    enable = lib.mkEnableOption "Enable virtualization tools";
  };

  config = lib.mkIf cfg.enable {
    # Enable docker
    virtualisation.docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };

    environment.systemPackages = with pkgs; [ lazydocker ];
  };
}
