# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{ inputs, pkgs, ... }:
{
  imports = [
    "${inputs.self}/modules/nixos"

    "${inputs.self}/modules/nixos/desktop"
    "${inputs.self}/modules/nixos/development"

    "${inputs.self}/modules/nixos/steam.nix"
  ];

  environment = {
    systemPackages = with pkgs; [
      appflowy
      bitwarden-cli
      bitwarden-desktop
      discord
      element-desktop
      feishin
      gimp
      kdePackages.kdenlive
      obsidian
      picard
      protonmail-desktop
      yt-dlp
    ];

    variables = {
      EDITOR = "nvim";
    };
  };

  programs = {
    localsend = {
      enable = true;
      # default port = 53317
      # required for functionality
      openFirewall = true;
    };
    # NOTE: cheat to run binaries like AppFlowy-LAI
    #       https://github.com/NixOS/nixpkgs/issues/425964
    nix-ld.enable = true;
  };

  custom.nixos = {
    # desktop.kde.enable = true;
    desktop.gnome.enable = true;
    development = {
      cli.enable = true;
      nh.enable = true;
    };
    steam.enable = true;
  };
}
