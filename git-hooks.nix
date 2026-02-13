{
  # https://github.com/cachix/git-hooks.nix
  hooks = {
    beautysh.enable = true; # format bash files
    check-added-large-files.enable = true; # warning about large files (lfs?)
    check-merge-conflicts.enable = true; # don't commit merge conflicts
    commitizen.enable = true; # ensure conventional commits standard
    deadnix.enable = true; # remove any unused variabes and imports
    end-of-file-fixer.enable = true; # add a line at the end of the file
    flake-checker.enable = false; # run `flake check`
    markdownlint.enable = true; # format markdown files
    nil.enable = true; # lsp that also has formatter
    nixfmt.enable = true; # format nix files to rfc standards
    shfmt.enable = true; # another formatter
    statix.enable = true; # check "good practices" for nix
    trim-trailing-whitespace.enable = true; # trim trailing whitespace
  };
}
