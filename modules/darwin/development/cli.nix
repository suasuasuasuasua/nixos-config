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
      # docker # TODO: either use nixpkgs version (with service) or brew
      btop # monitor of resources
      fastfetch # system information tool
      fd # find alternative
      ffmpeg # solution to record, convert and stream audio and video
      just # save command line configs
      macpm # perf monitoring cli tool for apple silicon
      manix # cli tool for nix packages
      nix-output-monitor # processes output of nix commands to show information
      nvd # nix/nixos package version diff tool
      onefetch # git repository summary on your terminal
      ripgrep
      tea # gitea command line tool helper
      tree
      yt-dlp # cli tool to download videos from YouTube.com and other sites
      zstd # Zstandard real-time compression algorithm
    ];
  };
}
