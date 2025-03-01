{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.darwin.development.utm;
in
{
  options.darwin.development.utm = {
    enable = lib.mkEnableOption "Enable UTM virtual machine manager";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      utm
    ];
  };
}
