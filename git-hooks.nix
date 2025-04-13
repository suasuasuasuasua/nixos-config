{
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
    nixfmt-rfc-style.enable = true; # format nix files to rfc standards
    deadnix.enable = true; # remove any unused variabes and imports
    # https://github.com/determinatesystems/flake-checker/issues/156
    flake-checker.enable = false; # run `flake check`
    statix.enable = true; # check "good practices" for nix
    nil.enable = true; # lsp that also has formatter

    # Shell
    beautysh.enable = true; # format bash files
    shellcheck.enable = true; # static shell script checker
    shfmt.enable = true; # another formatter
  };
}
