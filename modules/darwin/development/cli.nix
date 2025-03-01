{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.darwin.development.cli;
in
{
  options.darwin.development.cli = {
    enable = lib.mkEnableOption "Enable general CLI tools";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ffmpeg
      yt-dlp
      zstd
    ];
  };
}
