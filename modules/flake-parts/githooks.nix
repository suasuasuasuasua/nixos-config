{ inputs, ... }:
{
  imports = [
    inputs.git-hooks-nix.flakeModule
  ];
  perSystem = _: {
    pre-commit.settings.hooks = {
      # Nix
      nixfmt-rfc-style.enable = true;
      deadnix.enable = true; # kind of annoying in practice
      flake-checker.enable = true;
      statix.enable = true;
      nil.enable = true;

      # Git
      commitizen.enable = true;
      ripsecrets.enable = true;

      # Docs
      markdownlint.enable = true;

      # General
      check-added-large-files.enable = true;
      check-merge-conflicts.enable = true;
      end-of-file-fixer.enable = true;
      trim-trailing-whitespace.enable = true;
    };
  };
}
