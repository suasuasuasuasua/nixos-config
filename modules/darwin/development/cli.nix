{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.darwin.development.cli;
in
{
  options.custom.darwin.development.cli = {
    enable = lib.mkEnableOption "Enable general CLI tools";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      asitop # perf monitoring cli tool for apple silicon
      btop # monitor of resources
      # docker # TODO: either use nixpkgs version (with service) or brew
      fastfetch # system information tool
      ffmpeg # solution to record, convert and stream audio and video
      manix # cli tool for nix packages
      nvd # nix/nixos package version diff tool
      onefetch # git repository summary on your terminal
      tea # gitea command line tool helper
      tree
      yt-dlp # cli tool to download videos from YouTube.com and other sites
      zstd # Zstandard real-time compression algorithm
    ];
  };
}
