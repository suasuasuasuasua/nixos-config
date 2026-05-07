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
    environment.systemPackages = [
      # docker # TODO: either use nixpkgs version (with service) or brew
      pkgs.btop # monitor of resources
      pkgs.fastfetch # system information tool
      pkgs.fd # find alternative
      pkgs.ffmpeg # solution to record, convert and stream audio and video
      pkgs.just # save command line configs
      pkgs.macpm # perf monitoring cli tool for apple silicon
      pkgs.manix # cli tool for nix packages
      pkgs.nix-output-monitor # processes output of nix commands to show information
      pkgs.nvd # nix/nixos package version diff tool
      pkgs.onefetch # git repository summary on your terminal
      pkgs.ripgrep
      pkgs.tea # gitea command line tool helper
      pkgs.tree
      pkgs.yt-dlp # cli tool to download videos from YouTube.com and other sites
      pkgs.zstd # Zstandard real-time compression algorithm
    ];
  };
}
