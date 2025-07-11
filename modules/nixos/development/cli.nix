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
    environment.systemPackages = with pkgs; [
      btop # monitor of resources
      curl # command line tool for transferring files with url syntax
      dig # domain name server
      fastfetch # system information tool
      just # save command line configs
      lshw # show information on the hardware configuration of the machine
      nix-output-monitor # processes output of nix commands to show information
      onefetch # git repository summary on your terminal
      python3
      speedtest-cli # cli for testing internet bandwidth using speedtest.net
      tea # gitea cli tool
      unzip # extraction utility for archives compressed in .zip format
      wget # tool for retrieving files using http, https, and ftp
      wl-clipboard # command-line copy/paste utilities for wayland
      zip # compressor/archiver for creating and modifying zipfiles
    ];
  };
}
