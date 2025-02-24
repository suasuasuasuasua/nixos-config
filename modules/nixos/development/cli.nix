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
  options.nixos.development.cli = {
    enable = lib.mkEnableOption "Enable general CLI tools";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # Files
      zip
      unzip
      wget
      curl

      lshw

      # Allow copy and paste in apps like neovim
      wl-clipboard
    ];
  };
}
