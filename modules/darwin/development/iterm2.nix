{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.darwin.development.iterm2;
in
{
  options.darwin.development.iterm2 = {
    enable = lib.mkEnableOption "Enable iTerm2 terminal emulator";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      iterm2
    ];
  };
}
