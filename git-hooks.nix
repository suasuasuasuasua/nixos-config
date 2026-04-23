{
  # https://github.com/cachix/git-hooks.nix
  hooks = {
    check-added-large-files.enable = true; # warning about large files (lfs?)
    check-merge-conflicts.enable = true; # don't commit merge conflicts
    commitizen.enable = true; # ensure conventional commits standard
    deadnix.enable = true; # remove any unused variabes and imports
    end-of-file-fixer.enable = true; # add a line at the end of the file
    flake-checker.enable = false; # run `flake check`
    statix.enable = true; # check "good practices" for nix
    trim-trailing-whitespace.enable = true; # trim trailing whitespace
  };
}
