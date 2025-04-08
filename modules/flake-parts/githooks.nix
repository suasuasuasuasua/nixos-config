{ inputs, ... }:
{
  imports = [ inputs.git-hooks-nix.flakeModule ];

  # https://github.com/cachix/git-hooks.nix
  perSystem = _: {
    pre-commit.settings.hooks = {
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
      nixfmt-rfc-style.enable = true; # format nix files to rfc standards
      deadnix.enable = true; # remove any unused variabes and imports
      flake-checker.enable = true; # run `flake check`
      statix.enable = true; # check "good practices" for nix
      nil.enable = true; # lsp that also has formatter

      # Shell
      beautysh.enable = true; # format bash files
      shellcheck.enable = true; # static shell script checker
      shfmt.enable = true; # another formatter
    };
  };
}
