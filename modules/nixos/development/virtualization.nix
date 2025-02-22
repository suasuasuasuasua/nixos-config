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
