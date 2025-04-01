{ inputs, ... }:
{
  imports = [
    inputs.git-hooks-nix.flakeModule
  ];
  perSystem = _: {
    pre-commit.settings.hooks = {
      # Nix
      nixfmt-rfc-style.enable = true; # format nix files to rfc standards
      deadnix.enable = true; # remove any unused variabes and imports
      flake-checker.enable = true; # run `flake check`
      statix.enable = true; # check "good practices" for nix
      nil.enable = true; # lsp that also has formatter

      # Git
      commitizen.enable = true; # ensure conventional commits standard
      ripsecrets.enable = true; # remove any hardcoded secrets

      # Docs
      markdownlint.enable = true; # format markdown files

      # General
      check-added-large-files.enable = true; # warning about large files (lfs?)
      check-merge-conflicts.enable = true; # don't commit merge conflicts
      end-of-file-fixer.enable = true; # add a line at the end of the file
      trim-trailing-whitespace.enable = true; # trim trailing whitespace
    };
  };
}
