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
      asitop # perf monitoring cli tool for apple silicon
      ffmpeg # solution to record, convert and stream audio and video
      yt-dlp # cli tool to download videos from YouTube.com and other sites
      zstd # Zstandard real-time compression algorithm
    ];
  };
}
