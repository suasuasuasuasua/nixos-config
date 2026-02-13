{
  # Used to find the project root
  projectRootFile = "flake.nix";

  # Run the following programs on `nix fmt`
  programs = {
    beautysh.enable = true; # bash
    jsonfmt.enable = true; # format json
    just.enable = true; # format just files
    mdformat.enable = true; # format markdown
    nixfmt.enable = true;
    yamlfmt.enable = true; # format yaml
  };

  # ignore certain files
  settings.global.excludes = [
    "*.png"
    ".envrc"
  ];
}
