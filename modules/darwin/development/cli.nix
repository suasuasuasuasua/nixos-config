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
      # dev
      # docker # TODO: either use nixpkgs version (with service) or brew

      # files
      zstd # Zstandard real-time compression algorithm

      # media
      ffmpeg # solution to record, convert and stream audio and video
      yt-dlp # cli tool to download videos from YouTube.com and other sites

      # system monitoring
      asitop # perf monitoring cli tool for apple silicon
      btop # monitor of resources
      fastfetch # system information tool
      onefetch # git repository summary on your terminal

      # nix utilty
      nvd # nix/nixos package version diff tool
    ];
  };
}
