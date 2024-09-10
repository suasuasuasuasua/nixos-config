{
  programs.direnv = {
    # enable = true;
    enable = true;
    enableZshIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
  };
}
