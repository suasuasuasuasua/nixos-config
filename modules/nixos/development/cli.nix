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
      # hardware
      lshw # show information on the hardware configuration of the machine

      # file operations
      curl # command line tool for transferring files with url syntax
      unzip # extraction utility for archives compressed in .zip format
      wget # tool for retrieving files using http, https, and ftp
      wl-clipboard # command-line copy/paste utilities for wayland
      zip # compressor/archiver for creating and modifying zipfiles

      # system monitoring
      btop # monitor of resources
      fastfetch # system information tool
      onefetch # git repository summary on your terminal

      # scripting
      python3
    ];
  };
}
