{ pkgs, ... }:
{
  # https://github.com/cachix/git-hooks.nix
  hooks = {
    # Docs
    markdownlint.enable = true; # format markdown files

    # Git
    commitizen.enable = true; # ensure conventional commits standard
    ripsecrets.enable = true; # remove any hardcoded secrets

    # General
    check-added-large-files.enable = true; # warning about large files (lfs?)
    check-merge-conflicts.enable = true; # don't commit merge conflicts
    end-of-file-fixer.enable = true; # add a line at the end of the file
    trim-trailing-whitespace.enable = true; # trim trailing whitespace

    # Nix
    deadnix.enable = true; # remove any unused variabes and imports
    flake-checker = {
      enable = true; # run `flake check`
      # TODO: remove when v0.2.6 hits main nixpkgs
      # 25.05 should be valid now.
      # https://discourse.nixos.org/t/nixpkgs-overlay-for-mpd-discord-rpc-is-no-longer-working/59982/2
      # https://discourse.nixos.org/t/how-do-you-override-the-commit-rev-used-by-a-rust-package/47698/6
      package = pkgs.flake-checker.overrideAttrs rec {
        pname = "flake-checker";
        version = "0.2.6";

        src = pkgs.fetchFromGitHub {
          owner = "DeterminateSystems";
          repo = "flake-checker";
          rev = "v0.2.6";
          hash = "sha256-qEdwtyk5IaYCx67BFnLp4iUN+ewfPMl/wjs9K4hKqGc=";
        };
        cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
          inherit src;
          hash = "sha256-5eaVjrAPxBQdG+LQ6mQ/ZYAdslpdK3mrZ5Vbuwe3iQw=";
        };
        # NOTE: not working this way for some reason -- something about
        # updating the cargoHash but that is never output
        # cargoDeps = drv.cargoDeps.overrideAttrs {
        #   inherit src;
        #   hash = "sha256-5eaVjrAPxBQdG+LQ6mQ/ZYAdslpdK3mrZ5Vbuwe3iQw=";
        # };
      };
    };

    nil.enable = true; # lsp that also has formatter
    nixfmt-rfc-style.enable = true; # format nix files to rfc standards
    statix.enable = true; # check "good practices" for nix

    # Shell
    beautysh.enable = true; # format bash files
    shellcheck.enable = true; # static shell script checker
    shfmt.enable = true; # another formatter
  };
}
