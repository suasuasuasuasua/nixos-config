{pkgs, ...}: {
  # https://devenv.sh/packages/
  packages = with pkgs; [
    git
    pre-commit
    commitizen

    just

    markdownlint-cli
    nixfmt-rfc-style

    fastfetch
    onefetch
  ];

  # https://devenv.sh/pre-commit-hooks/
  pre-commit.hooks = {
    # Nix
    alejandra.enable = true;
    deadnix.enable = true;
    flake-checker.enable = true;

    # Git
    commitizen.enable = true;
    ripsecrets.enable = true;

    # Docs
    typos.enable = true;
    markdownlint.enable = true;

    # General
    check-added-large-files.enable = true;
    check-merge-conflicts.enable = true;
    end-of-file-fixer.enable = true;
    trim-trailing-whitespace.enable = true;
  };

  # See full reference at https://devenv.sh/reference/options/
}
