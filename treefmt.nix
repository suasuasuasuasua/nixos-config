{ pkgs, ... }:
{
  # Used to find the project root
  projectRootFile = "flake.nix";

  # Run the following programs on `nix fmt`
  programs = {
    # bash
    beautysh.enable = true; # bash

    # json
    jsonfmt.enable = true; # format json

    # just
    just.enable = true; # format just files

    # markdown
    mdformat.enable = true; # format markdown

    # nix
    nixfmt = {
      # format the nix files
      enable = pkgs.lib.meta.availableOn pkgs.stdenv.buildPlatform pkgs.nixfmt-rfc-style.compiler;
      package = pkgs.nixfmt-rfc-style;
    };

    # yaml
    yamlfmt.enable = true; # format yaml
  };

  # ignore certain files
  settings.global.excludes = [
    "*.png"
    ".envrc"
  ];
}
