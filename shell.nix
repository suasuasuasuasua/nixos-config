{
  self,
  pkgs,
  ...
}:
let
  inherit (pkgs) system;
in
pkgs.mkShellNoCC {
  # enable the shell hooks
  shellHook =
    # bash
    ''
      git remote update && git status -uno
    ''
    # install the git hooks
    + self.checks.${system}.git-hooks-check.shellHook;

  # define the programs available when running `nix develop`
  # add the packages from the git-hooks list too
  buildInputs = self.checks.${system}.git-hooks-check.enabledPackages;
  packages =
    with pkgs;
    let
      inherit (pkgs.stdenv) isDarwin;
    in
    [
      # cli
      btop # system monitoring
      fastfetch # system information

      # commands
      bat # better cat
      just # command runner
      tokei # lines of code
      vim-startuptime # proflie vim and neovim

      # lsp
      nil # lsp 1
      nixd # lsp 2
      nixfmt-rfc-style # nix formatter
      markdownlint-cli # markdown linter

      # nix support
      home-manager
      nix
      # TODO: replace nh in 25.05 once version >4.0.0 hits stable
      (if isDarwin then unstable.nh else nh) # nix helper
      nix-output-monitor # nix output monitor
      nvd # nix/nixos package version diff tool

      # source control
      commitizen # templated commits and bumping
      git # source control program
    ];
}
