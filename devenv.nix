{pkgs, ...}: {
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = with pkgs; [
    git
    pre-commit
    commitizen

    just

    fastfetch
  ];

  # https://devenv.sh/scripts/
  scripts.hello.exec = ''
    echo hello from $GREET
  '';

  enterShell = ''
  '';

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
