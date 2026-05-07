{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.nixos.development.cli;
in
{
  options.custom.nixos.development.cli = {
    enable = lib.mkEnableOption "Enable general CLI tools";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.btop # monitor of resources
      pkgs.curl # command line tool for transferring files with url syntax
      pkgs.dig # domain name server
      pkgs.diskus # paralellelized du (disk usage)
      pkgs.fastfetch # system information tool
      pkgs.fd # find alternative
      pkgs.hyperfine # performance judement program
      pkgs.just # save command line configs
      pkgs.lshw # show information on the hardware configuration of the machine
      pkgs.manix # cli tool for nix packages
      pkgs.ncdu # curses interface to du
      pkgs.nix-output-monitor # processes output of nix commands to show information
      pkgs.onefetch # git repository summary on your terminal
      pkgs.python3
      pkgs.ripgrep # grep alternative
      pkgs.speedtest-cli # cli for testing internet bandwidth using speedtest.net
      pkgs.tea # gitea cli tool
      pkgs.tree
      pkgs.unzip # extraction utility for archives compressed in .zip format
      pkgs.wget # tool for retrieving files using http, https, and ftp
      pkgs.wl-clipboard # command-line copy/paste utilities for wayland
      pkgs.zip # compressor/archiver for creating and modifying zipfiles
    ];
  };
}
